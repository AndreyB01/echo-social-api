module Auth
  class RefreshTokenGenerator
    TOKEN_LENGTH = 64

    def self.call(user:, device_name: nil)
      raw_token = SecureRandom.hex(TOKEN_LENGTH)

      token_digest = digest_token(raw_token)

      refresh_token = RefreshToken.create!(
        user: user,
        token_digest: token_digest,
        expires_at: 30.days.from_now,
        device_name: device_name
      )

      {
        raw_token: raw_token,
        refresh_token_record: refresh_token
      }
    end

    def self.digest_token(token)
      Digest::SHA256.hexdigest(token)
    end
  end
end