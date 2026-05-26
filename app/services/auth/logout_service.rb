module Auth
  class LogoutService
    class InvalidSessionError < StandardError; end

    def self.call(refresh_token:)
      new(refresh_token).call
    end

    def initialize(refresh_token)
      @refresh_token = refresh_token
    end

    def call
      refresh_token_digest =
        Digest::SHA256.hexdigest(
          refresh_token
        )

      session =
        UserSession.find_by(
          refresh_token_digest:
            refresh_token_digest
        )

      raise InvalidSessionError unless session

      session.update!(
        revoked_at: Time.current
      )

      true
    end

    private

    attr_reader :refresh_token
  end
end