module Api
  module V1
    class ProfilesController < Api::BaseController
      before_action :authenticate_user!

      def show
        render_success(
          data: UserSerializer.render(current_user)
        )
      end
    end
  end
end