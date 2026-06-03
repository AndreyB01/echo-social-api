module Api
  module V1
    module Auth
      class SessionsController < Api::BaseController
        def create
          tokens = ::Auth::LoginService.call(
            login: login_params[:login],
            password: login_params[:password],
            user_agent: request.user_agent,
            ip_address: request.remote_ip
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
            :login,
            :password
          )
        end
      end
    end
  end
end