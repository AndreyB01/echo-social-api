module Api
  module V1
    module Auth
      class RegistrationsController < ApplicationController
        def create
          user = Users::CreateService.call(user_params)

          render json: user_response(user),
                 status: :created
        rescue ActiveRecord::RecordInvalid => e
          render json: {
            errors: e.record.errors.full_messages
          },
                 status: :unprocessable_content
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

        def user_response(user)
          {
            data: {
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
          }
        end
      end
    end
  end
end