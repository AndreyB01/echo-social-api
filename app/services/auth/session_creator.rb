module Auth
  class SessionCreator
    TOKEN_LENGTH = 64

    def self.call(user:, user_agent: nil, ip_address: nil)
      raw_refresh_token = SecureRandom.hex(TOKEN_LENGTH)

      refresh_token_digest =
        Digest::SHA256.hexdigest(raw_refresh_token)

      session = UserSession.create!(
        user: user,
        refresh_token_digest: refresh_token_digest,
        user_agent: user_agent,
        ip_address: ip_address,
        expires_at: 30.days.from_now
      )

      {
        session: session,
        refresh_token: raw_refresh_token
      }
    end
  end
end