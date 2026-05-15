module Jwt
  class Decoder
    SECRET_KEY = ENV.fetch("JWT_SECRET")

    def self.call(token)
      decoded_token = JWT.decode(
        token,
        SECRET_KEY,
        true,
        algorithm: "HS256"
      )

      decoded_token.first
    end
  end
end