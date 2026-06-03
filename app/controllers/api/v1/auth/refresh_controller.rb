module Api
  module V1
    module Auth
      class RefreshController < ApplicationController
        rescue_from ::Auth::RefreshService::InvalidTokenError do
          render json: {
            error: "Invalid refresh token"
          }, status: :unauthorized
        end

        def create
          tokens = ::Auth::RefreshService.call(
            refresh_token: params[:refresh_token]
          )

          render json: {
            access_token: tokens[:access_token],
            refresh_token: tokens[:refresh_token],
            token_type: "Bearer",
            expires_in: 15.minutes.to_i
          }, status: :ok
        end
      end
    end
  end
end