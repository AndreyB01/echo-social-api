module Api
  module V1
    class ProfilesController < Api::BaseController
      before_action :authenticate_user!

      def show
        render_success(
          data: UserSerializer.render(current_user)
        )
      end

      def update
        if current_user.update(profile_params)
          render_success(
            data: UserSerializer.render(current_user)
          )
        else
          render_validation_error(current_user)
        end
      end

      private

      def profile_params
        params.require(:user).permit(
          :display_name,
          :bio,
          :avatar
        )
      end
    end
  end
end