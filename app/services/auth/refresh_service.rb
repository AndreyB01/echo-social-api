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
      refresh_token_digest =
        Digest::SHA256.hexdigest(
          refresh_token
        )

      session =
        UserSession.find_by(
          refresh_token_digest:
            refresh_token_digest
        )

      raise InvalidTokenError unless session

      raise InvalidTokenError if session.revoked_at.present?

      raise InvalidTokenError if session.expires_at.past?

      new_refresh_token =
        SecureRandom.hex(64)

      new_refresh_digest =
        Digest::SHA256.hexdigest(
          new_refresh_token
        )

      session.update!(
        refresh_token_digest:
          new_refresh_digest
      )

      access_token =
      Jwt::AccessTokenEncoder.call(
        user: session.user,
        session: session
      )

      {
        access_token: access_token,
        refresh_token: new_refresh_token,
        session: session
      }
    end

    private

    attr_reader :refresh_token
  end
end