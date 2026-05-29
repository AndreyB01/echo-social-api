module Api
  module V1
    module Auth
      class LogoutController < ApplicationController
        before_action :authenticate_user!,
                      only: :destroy_all

        def destroy
          ::Auth::LogoutService.call(
            refresh_token:
              logout_params[:refresh_token]
          )

          render json: {
            message: "Logged out successfully"
          }, status: :ok
        rescue ::Auth::LogoutService::InvalidSessionError
          render json: {
            error: "Invalid refresh token"
          }, status: :unauthorized
        end

        def destroy_all
          ::Auth::LogoutAllService.call(
            user: current_user
          )

          render json: {
            message: "Logged out from all devices"
          }, status: :ok
        end

        private

        def logout_params
          params.permit(:refresh_token)
        end
      end
    end
  end
end