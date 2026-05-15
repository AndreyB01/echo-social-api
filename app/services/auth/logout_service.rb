module Auth
  class LogoutService
    class InvalidTokenError < StandardError; end

    def self.call(refresh_token:)
      new(refresh_token).call
    end

    def initialize(refresh_token)
      @refresh_token = refresh_token
    end

    def call
      token_digest =
        Auth::RefreshTokenGenerator.digest_token(
          refresh_token
        )

      stored_token =
        RefreshToken.active.find_by(
          token_digest: token_digest
        )

      raise InvalidTokenError unless stored_token

      stored_token.update!(
        revoked_at: Time.current
      )
    end

    private

    attr_reader :refresh_token
  end
end