module Api
  module V1
    module Admin
      class UsersController < BaseController
        def ban
          user = User.find(params[:id])

          user.update!(
            banned_at: Time.current
          )

          render json: user
        end
      end
    end
  end
end

