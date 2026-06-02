module Api
  module V1
    module Auth
      class ResendConfirmationsController < Api::BaseController
        def create
          user = User.find_by(email: params[:email])

          return head :ok unless user

          return head :ok if user.confirmed?

          token_data =
            Auth::EmailConfirmationTokenGenerator.call(
              user: user
            )

          UserMailer
            .confirmation_email(
              user,
              token_data[:raw_token]
            )
            .deliver_later

          render json: {
            message: "Confirmation email sent"
          }, status: :ok
        end
      end
    end
  end
end

