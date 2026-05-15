module Api
  module V1
    module Auth
      class SessionsController < ApplicationController
        def create
  tokens = ::Auth::LoginService.call(
    email: login_params[:email],
    password: login_params[:password]
  )

  render json: {
    access_token: tokens[:access_token],
    refresh_token: tokens[:refresh_token],
    token_type: "Bearer"
  }, status: :ok
rescue ::Auth::LoginService::InvalidCredentialsError
  render json: {
    error: "Invalid credentials"
  }, status: :unauthorized
end

        private

        def login_params
          params.require(:user).permit(
            :email,
            :password
          )
        end
      end
    end
  end
end