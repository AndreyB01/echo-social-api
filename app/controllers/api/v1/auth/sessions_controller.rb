module Api
  module V1
    module Auth
      class SessionsController < Api::BaseController
        def create
          tokens = ::Auth::LoginService.call(
            email: login_params[:email],
            password: login_params[:password]
          )

          render_success(
            data: {
              access_token: tokens[:access_token],
              refresh_token: tokens[:refresh_token],
              token_type: "Bearer"
            }
          )
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