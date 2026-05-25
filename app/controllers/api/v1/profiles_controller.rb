module Api
  module V1
    class ProfilesController < Api::BaseController
      before_action :authenticate_user!

      def show
        render_success(
          data: serialized_user(current_user)
        )
      end

      private

      def serialized_user(user)
        {
          id: user.id,
          email: user.email,
          username: user.username,
          display_name: user.display_name
        }
      end
    end
  end
end