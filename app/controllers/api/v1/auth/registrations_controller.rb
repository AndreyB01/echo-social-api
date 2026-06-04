module Api
  module V1
    module Auth
      class RegistrationsController < Api::BaseController
        def create
          user = Users::CreateService.call(user_params)

          render_success(
            data: serialized_user(user),
            status: :created
          )
        rescue ActiveRecord::RecordInvalid => e
          # Privacy-safe: логируем детали, но в ответе общая ошибка
          Rails.logger.info("Registration failed: #{e.record.errors.full_messages.join(', ')}")
          render json: {
            error: {
              code: "validation_failed",
              message: "Could not create account"
            }
          }, status: :unprocessable_entity
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