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
        posts = Post.includes(
          :user,
          :hashtags
        ).order(created_at: :desc)
         .page(params[:page])
         .per(params[:per_page] || 20)

        render_success(
          data: PostSerializer.render_collection(posts),
          meta: {
            current_page: posts.current_page,
            next_page: posts.next_page,
            prev_page: posts.prev_page,
            total_pages: posts.total_pages,
            total_count: posts.total_count
          }
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
        @post = Post.includes(
          :user,
          :hashtags
        ).find(params[:id])
      end

      def post_params
        params.require(:post).permit(:body)
      end
    end
  end
end