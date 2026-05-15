class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    post = Post.find(params[:post_id])

    comments = post.comments.includes(:user).order(created_at: :asc)

    render json: {
      data: comments.map { |comment| serialize_comment(comment) }
    }
  end

  def create
    post = Post.find(params[:post_id])

    comment = current_user.comments.create!(
      post: post,
      body: comment_params[:body]
    )

    render json: {
      data: serialize_comment(comment)
    }, status: :created
  end

  def destroy
    comment = current_user.comments.find(params[:id])

    comment.destroy!

    render json: {
      success: true
    }
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def serialize_comment(comment)
    {
      id: comment.id,
      body: comment.body,
      created_at: comment.created_at,
      author: {
        id: comment.user.id,
        username: comment.user.username,
        display_name: comment.user.display_name
      }
    }
  end
end