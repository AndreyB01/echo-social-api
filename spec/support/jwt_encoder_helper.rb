module Jwt
  class Encoder
    def self.call(user_id:)
      user = User.find(user_id)
      session = UserSession.create!(
        user: user,
        refresh_token_digest: SecureRandom.hex(32),
        user_agent: "RSpec",
        ip_address: "127.0.0.1",
        expires_at: 30.days.from_now
      )
      Jwt::AccessTokenEncoder.call(user: user, session: session)
    end
  end
end

