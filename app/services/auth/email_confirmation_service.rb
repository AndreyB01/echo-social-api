module Auth
  class EmailConfirmationService
    class InvalidTokenError < StandardError; end

    def self.call(token:)
      new(token).call
    end

    def initialize(token)
      @token = token
    end

    def call
      token_digest =
        Auth::EmailConfirmationTokenGenerator
          .digest_token(token)

      user =
        User.find_by(
          confirmation_token_digest: token_digest
        )

      raise InvalidTokenError unless user

      user.update!(
        confirmed_at: Time.current,
        confirmation_token_digest: nil,
        confirmation_sent_at: nil
      )

      user
    end

    private

    attr_reader :token
  end
end