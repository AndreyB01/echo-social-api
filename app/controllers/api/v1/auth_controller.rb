def refresh
  refresh_token = RefreshToken.find_by(token: params[:refresh_token])

  if refresh_token.nil? || refresh_token.expired?
    render json: { error: "Invalid refresh token" }, status: :unauthorized
    return
  end

  user = refresh_token.user

  refresh_token.destroy!

  new_refresh_token = user.refresh_tokens.create!(
    token: SecureRandom.hex(64),
    expires_at: 30.days.from_now
  )

  access_token = JwtService.encode(user_id: user.id)

  render json: {
    access_token: access_token,
    refresh_token: new_refresh_token.token,
    token_type: "Bearer"
  }
end
