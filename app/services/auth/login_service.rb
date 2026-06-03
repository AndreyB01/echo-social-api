module Auth
  class LoginService
    class InvalidCredentialsError < StandardError; end

    def self.call(
      login:,
      password:,
      user_agent:,
      ip_address:
    )
      new(
        login,
        password,
        user_agent,
        ip_address
      ).call
    end

    def initialize(
      login,
      password,
      user_agent,
      ip_address
    )
      @login = login
      @password = password
      @user_agent = user_agent
      @ip_address = ip_address
    end

    def call
      user =
        User.find_by(email: login) ||
        User.find_by(username: login)

      raise InvalidCredentialsError unless user

      authenticated_user =
        user.authenticate(password)

      raise InvalidCredentialsError unless authenticated_user
      raise InvalidCredentialsError unless user.confirmed_at?

      raw_refresh_token =
        SecureRandom.hex(64)

      refresh_token_digest =
        Digest::SHA256.hexdigest(
          raw_refresh_token
        )

      session = UserSession.create!(
        user: user,
        refresh_token_digest: refresh_token_digest,
        user_agent: user_agent,
        ip_address: ip_address,
        expires_at: 30.days.from_now
      )

      access_token =
        Jwt::AccessTokenEncoder.call(
          user: user,
          session: session
        )

      {
        access_token: access_token,
        refresh_token: raw_refresh_token,
        session: session
      }
    end

    private

    attr_reader(
      :login,
      :password,
      :user_agent,
      :ip_address
    )
  end
end