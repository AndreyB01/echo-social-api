module Api
  module V1
    module Auth
      class EmailConfirmationsController < Api::BaseController
        def show
          Auth::EmailConfirmationService.call(
            token: params[:token]
          )

          render json: {
            message: "Email confirmed successfully"
          }, status: :ok
        rescue Auth::EmailConfirmationService::InvalidTokenError
          render json: {
            error: "Invalid confirmation token"
          }, status: :unprocessable_entity
        end
      end
    end
  end
end