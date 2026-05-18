class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
  post = Post.find(params[:post_id])

  comments = post.comments
                 .includes(:user) 
                 .order(created_at: :asc)
                 .page(params[:page])
                 .per(params[:per_page] || 20)

  render json: {
    data: CommentSerializer.render_collection(comments),
    meta: {
      current_page: comments.current_page,
      next_page: comments.next_page,
      prev_page: comments.prev_page,
      total_pages: comments.total_pages,
      total_count: comments.total_count
    }
  }
end

def create
  post = Post.find(params[:post_id])

  comment = current_user.comments.create!(
    post: post,
    body: comment_params[:body]
  )

  render json: {
    data: CommentSerializer.render(comment)
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

  
end