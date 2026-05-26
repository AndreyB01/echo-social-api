module Auth
  class LoginService
    class InvalidCredentialsError < StandardError; end

    def self.call(
      email:,
      password:,
      user_agent:,
      ip_address:
    )
      new(
        email,
        password,
        user_agent,
        ip_address
      ).call
    end

    def initialize(
      email,
      password,
      user_agent,
      ip_address
    )
      @email = email
      @password = password
      @user_agent = user_agent
      @ip_address = ip_address
    end

    def call
      user = User.find_by(email: email)

      raise InvalidCredentialsError unless user

      authenticated_user =
        user.authenticate(password)

      raise InvalidCredentialsError unless authenticated_user
      raise InvalidCredentialsError unless user.confirmed_at?
      
      session = UserSession.create!(
        user: user,
        refresh_token_digest: nil,
        user_agent: user_agent,
        ip_address: ip_address,
        expires_at: 30.days.from_now
      )

      raw_refresh_token =
        SecureRandom.hex(64)

      refresh_token_digest =
        Digest::SHA256.hexdigest(
          raw_refresh_token
        )

      session.update!(
        refresh_token_digest:
          refresh_token_digest
      )

      access_token =
        Jwt::AccessTokenEncoder.call(
          {
            user_id: user.id,
            session_id: session.id
          }
        )

      {
        access_token: access_token,
        refresh_token: raw_refresh_token,
        session: session
      }
    end

    private

    attr_reader(
      :email,
      :password,
      :user_agent,
      :ip_address
    )
  end
end