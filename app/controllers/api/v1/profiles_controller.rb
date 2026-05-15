module Api
  module V1
    class ProfilesController < ::ApplicationController
      before_action :authenticate_user!

      def show
        render json: {
          data: {
            id: current_user.id,
            email: current_user.email,
            username: current_user.username,
            display_name: current_user.display_name
          }
        }, status: :ok
      end
    end
  end
end