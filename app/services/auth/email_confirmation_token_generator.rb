module Auth
  class EmailConfirmationTokenGenerator
    TOKEN_LENGTH = 64

    def self.call(user:)
      raw_token = SecureRandom.hex(TOKEN_LENGTH)

      token_digest = digest_token(raw_token)

      user.update!(
        confirmation_token_digest: token_digest,
        confirmation_sent_at: Time.current
      )

      {
        raw_token: raw_token,
        token_digest: token_digest
      }
    end

    def self.digest_token(token)
      Digest::SHA256.hexdigest(token)
    end
  end
end