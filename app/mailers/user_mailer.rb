class UserMailer < ApplicationMailer
  def confirmation_email(user, raw_token)
    @user = user
    @confirmation_url =
      "http://localhost:3000/api/v1/auth/confirm_email?token=#{raw_token}"

    mail(
      to: @user.email,
      subject: "Confirm your email"
    )
  end
end