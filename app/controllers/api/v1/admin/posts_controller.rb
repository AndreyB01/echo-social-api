module Api
  module V1
    module Admin
      class PostsController < BaseController
        def hide
          post = Post.find(params[:id])

          post.update!(
            hidden_at: Time.current
          )

          render json: post
        end
      end
    end
  end
end

