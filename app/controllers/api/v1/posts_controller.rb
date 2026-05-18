module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_post, only: %i[show update destroy]

      def index
        posts = Post.includes(:user, :hashtags)
                    .order(created_at: :desc)
                    .page(params[:page])
                    .per(params[:per_page] || 20)

        render json: {
          data: PostSerializer.render_collection(posts),
          meta: {
            current_page: posts.current_page,
            next_page: posts.next_page,
            prev_page: posts.prev_page,
            total_pages: posts.total_pages,
            total_count: posts.total_count
          }
        }
      end

      def create
        post = current_user.posts.new(post_params)

        if post.save
          render json: {
            data: PostSerializer.render(post)
          }, status: :created
        else
          render json: {
            errors: post.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def show
        render json: {
          data: PostSerializer.render(@post)
        }, status: :ok
      end

      def update
        authorize(@post, :update?)

        if @post.update(post_params)
          render json: {
            data: PostSerializer.render(@post)
          }, status: :ok
        else
          render json: {
            errors: @post.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize(@post, :destroy?)
        @post.destroy

        head :no_content
      end

      private

      def set_post
        @post = Post.includes(:user, :hashtags).find(params[:id])
      end

      def post_params
        params.require(:post).permit(:body)
      end
    end
  end
end