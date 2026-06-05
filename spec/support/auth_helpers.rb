module AuthHelpers
  def auth_token_for(user)
    session = UserSession.create!(
      user: user,
      refresh_token_digest: SecureRandom.hex(32),
      expires_at: 30.days.from_now
    )

    Jwt::AccessTokenEncoder.call(
      user: user,
      session: session
    )
  end
end