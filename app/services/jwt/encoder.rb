module Jwt
  class Encoder
    SECRET_KEY = ENV.fetch("JWT_SECRET")

    def self.call(payload)
      payload[:exp] = 15.minutes.from_now.to_i

      JWT.encode(payload, SECRET_KEY, "HS256")
    end
  end
end