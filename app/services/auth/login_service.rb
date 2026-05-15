module Auth
  class LoginService
    class InvalidCredentialsError < StandardError; end

    def self.call(email:, password:)
      new(email, password).call
    end

    def initialize(email, password)
      @email = email
      @password = password
    end

    def call
  user = User.find_by(email: email)

  raise InvalidCredentialsError unless user

  authenticated_user = user.authenticate(password)

  raise InvalidCredentialsError unless authenticated_user

  access_token = Jwt::Encoder.call(
    user_id: user.id
  )

  refresh_token_data =
    Auth::RefreshTokenGenerator.call(
      user: user
    )

  {
    access_token: access_token,
    refresh_token: refresh_token_data[:raw_token]
  }
end

    private

    attr_reader :email, :password
  end
end