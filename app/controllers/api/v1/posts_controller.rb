module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_post, only: %i[
        show
        update
        destroy
      ]

      def index
        result = FeedQuery.new(
          user: current_user,
          cursor: params[:cursor],
          limit: params[:limit]
        ).call

        render_success(
          data: PostSerializer.render_collection(
            result[:records]
          ),
          meta: result[:meta]
        )
      end

      def create
        post = current_user.posts.new(post_params)

        if post.save
          render_success(
            data: PostSerializer.render(post),
            status: :created
          )
        else
          render_validation_error(post)
        end
      end

      def show
        render_success(
          data: PostSerializer.render(@post)
        )
      end

      def update
        authorize(@post, :update?)

        if @post.update(post_params)
          render_success(
            data: PostSerializer.render(@post)
          )
        else
          render_validation_error(@post)
        end
      end

      def destroy
        authorize(@post, :destroy?)

        @post.destroy

        render_success(
          data: {
            message: "Post deleted"
          }
        )
      end

      private

      def set_post
        @post = Post
                  .visible_to(current_user)
                  .includes(:user, :hashtags, images_attachments: :blob)
                  .find(params[:id])
      end

      def post_params
        params.require(:post).permit(:body, images: [])
      end
    end
  end
end