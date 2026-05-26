module Jwt
  class AccessTokenEncoder
    PRIVATE_KEY = OpenSSL::PKey::RSA.new(
      Rails.root.join("config/keys/jwt_private.pem").read
    )

    ALGORITHM = "RS256"

    def self.call(user:, session:)
      payload = {
        sub: user.id,
        session_id: session.id,
        type: "access",
        exp: 15.minutes.from_now.to_i
      }

      JWT.encode(payload, PRIVATE_KEY, ALGORITHM)
    end
  end
end