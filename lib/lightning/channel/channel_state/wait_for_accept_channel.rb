# frozen_string_literal: true

module Lightning
  module Channel
    class ChannelState
      class WaitForAcceptChannel < ChannelState
        def next(message, data)
          match message, (on ~AcceptChannel do |accept|
            input_init_funder = data[:init_funder]
            open_channel = data[:last_sent]
            local_param = input_init_funder[:local_param]

            # TODO: validate parameter
            remote_init = input_init_funder[:remote_init]
            funding_satoshis = input_init_funder[:funding_satoshis]
            initial_feerate_per_kw = input_init_funder[:initial_feerate_per_kw]
            push_msat = input_init_funder[:push_msat]
            remote_first_per_commitment_point = accept[:first_per_commitment_point]

            remote_param = RemoteParam[
              context.remote_node_id,
              accept[:dust_limit_satoshis],
              accept[:max_htlc_value_in_flight_msat],
              accept[:channel_reserve_satoshis],
              accept[:htlc_minimum_msat],
              accept[:to_self_delay],
              accept[:max_accepted_htlcs],
              accept[:funding_pubkey],
              accept[:revocation_basepoint],
              accept[:payment_basepoint],
              accept[:delayed_payment_basepoint],
              accept[:htlc_basepoint],
              remote_init.globalfeatures,
              remote_init.localfeatures
            ]
            local_funding_pubkey = local_param.funding_priv_key.pubkey
            funding_pubkey_script = Bitcoin::Script.to_p2wsh(
              Funding.pubkey_script(local_funding_pubkey, remote_param[:funding_pubkey])
            )
            # TODO : Implements Fee provider.
            funding_tx_feerate_per_kw = 1
            @channel << Funding.make_funding_tx(context.wallet, funding_pubkey_script, funding_satoshis, funding_tx_feerate_per_kw)

            goto(
              WaitForFundingInternal.new(@channel, context),
              data: DataWaitForFundingInternal[
                accept[:temporary_channel_id],
                local_param,
                remote_param,
                funding_satoshis,
                push_msat,
                initial_feerate_per_kw,
                remote_first_per_commitment_point,
                open_channel
              ]
            )
          end)
        end
      end
    end
  end
end
