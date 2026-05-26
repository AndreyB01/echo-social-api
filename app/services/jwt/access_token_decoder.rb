module Jwt
  class AccessTokenDecoder
    PUBLIC_KEY = OpenSSL::PKey::RSA.new(
      Rails.root.join("config/keys/jwt_public.pem").read
    )

    ALGORITHM = "RS256"

    def self.call(token)
      decoded_token = JWT.decode(
        token,
        PUBLIC_KEY,
        true,
        algorithm: ALGORITHM
      )

      decoded_token.first
    rescue JWT::DecodeError,
           JWT::ExpiredSignature
      nil
    end
  end
end