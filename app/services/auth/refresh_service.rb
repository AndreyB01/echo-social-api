module Auth
  class RefreshService
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

      RefreshToken.transaction do
        stored_token.update!(
          revoked_at: Time.current
        )

        new_access_token =
          Jwt::Encoder.call(
            user_id: stored_token.user.id
          )

        new_refresh_token_data =
          Auth::RefreshTokenGenerator.call(
            user: stored_token.user
          )

        {
          access_token: new_access_token,
          refresh_token:
            new_refresh_token_data[:raw_token]
        }
      end
    end

    private

    attr_reader :refresh_token
  end
end