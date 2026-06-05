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
        key = request.headers["Idempotency-Key"]
        if key.blank?
          return render json: { error: "idempotency_key required" }, status: :unprocessable_entity
        end

        idempotent = IdempotencyKey.find_by(user_id: current_user.id, key: key)
        if idempotent
          return render json: idempotent.response_body, status: idempotent.response_status
        end

        post = current_user.posts.create!(content: post_params[:content], images: post_params[:images])

        response = {
          data: post.as_json(include: { user: { only: %i[id username display_name avatar] }, hashtags: {}, mentions: {} })
        }

        IdempotencyKey.create!(
          key: key,
          user_id: current_user.id,
          response_status: :created,
          response_body: response
        )

        render json: response, status: :created
      end

      def show
        render_success(data: PostSerializer.render(@post))
      rescue => e
        render json: { error: e.message }, status: :internal_server_error
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
        if @post.user_id == current_user.id
          @post.soft_delete!
          render json: { message: "post deleted" }, status: :ok
        else
          render json: { error: "forbidden" }, status: :forbidden
        end
      end

      private

      def set_post
        base = Post.active.visible_to(current_user)
        if action_name == 'show'
          @post = base.includes(:user, :hashtags, images_attachments: :blob).find(params[:id])
        else
          @post = base.find(params[:id])
        end
      end

      def post_params
        params.require(:content) 
        params.permit(:content, images: [])
      end
    end
  end
end