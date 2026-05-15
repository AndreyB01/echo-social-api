module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_post, only: %i[show update destroy]

      def index
        limit = params.fetch(:limit, 20).to_i.clamp(1, 100)
        offset = params.fetch(:offset, 0).to_i

        posts = Post
          .includes(:user)
          .order(created_at: :desc)
          .limit(limit)
          .offset(offset)

        render json: {
          data: posts.map { |post| serialize_post(post) },
          meta: {
            limit: limit,
            offset: offset,
            count: posts.size
          }
        }
      end

      def create
        post = current_user.posts.new(post_params)

        if post.save
          render json: {
            data: serialize_post(post)
          }, status: :created
        else
          render json: {
            errors: post.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def show
        render json: {
          data: serialize_post(@post)
        }, status: :ok
      end

      def update
        authorize(@post, :update?)

        if @post.update(post_params)
          render json: {
            data: serialize_post(@post)
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
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(:body)
      end

      def serialize_post(post)
        {
          id: post.id,
          body: post.body,
          created_at: post.created_at,
          likes_count: post.likes.count,
          comments_count: post.comments.count,
          author: {
            id: post.user.id,
            username: post.user.username,
            display_name: post.user.display_name
          }
        }
      end
    end
  end
end