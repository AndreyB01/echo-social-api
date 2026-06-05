module Api
  module V1
    module Admin
      class BaseController < Api::BaseController
        before_action :authenticate_user!
        before_action :authorize_admin!

        private

        def authorize_admin!
          authorize(current_user, :access?)
        end
      end
    end
  end
end

