class Api::V1::LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.visible_to(current_user)
           .find(params[:post_id])

    like = current_user.likes.create!(post: post)

    render json: {
      data: {
        liked: true,
        likes_count: post.likes.count
      }
    }, status: :created
  end

  def destroy
    post = Post.visible_to(current_user)
           .find(params[:post_id])

    current_user.likes.find_by!(post: post).destroy!

    render json: {
      data: {
        liked: false,
        likes_count: post.likes.count
      }
    }
  end
end