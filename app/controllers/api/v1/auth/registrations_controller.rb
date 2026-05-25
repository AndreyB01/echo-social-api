module Api
  module V1
    module Auth
      class RegistrationsController < Api::BaseController
        def create
          user = Users::CreateService.call(
            user_params
          )

          render_success(
            data: serialized_user(user),
            status: :created
          )
        end

        private

        def user_params
          params.require(:user).permit(
            :email,
            :username,
            :password,
            :password_confirmation,
            :display_name,
            :bio
          )
        end

        def serialized_user(user)
          {
            id: user.id,
            type: "user",
            attributes: {
              email: user.email,
              username: user.username,
              display_name: user.display_name,
              bio: user.bio,
              created_at: user.created_at
            }
          }
        end
      end
    end
  end
end