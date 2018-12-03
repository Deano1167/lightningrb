# frozen_string_literal: true

module Lightning
  module Wire
    module LightningMessageTypes
      INIT = 16
      ERROR = 17
      PING = 18
      PONG = 19

      OPEN_CHANNEL = 32
      ACCEPT_CHANNEL = 33
      FUNDING_CREATED = 34
      FUNDING_SIGNED = 35
      FUNDING_LOCKED = 36
      SHUTDOWN = 38
      CLOSING_SIGNED = 39

      UPDATE_ADD_HTLC = 128
      UPDATE_FULFILL_HTLC = 130
      UPDATE_FAIL_HTLC = 131
      UPDATE_FAIL_MALFORMED_HTLC = 135
      COMMITMENT_SIGNED = 132
      REVOKE_AND_ACK = 133
      UPDATE_FEE = 134
      CHANNEL_REESTABLISH = 136

      ANNOUNCEMENT_SIGNATURES = 259
      CHANNEL_ANNOUNCEMENT = 256
      NODE_ANNOUNCEMENT = 257
      CHANNEL_UPDATE = 258
    end
  end
end
