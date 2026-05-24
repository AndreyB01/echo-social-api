class Api::V1::FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
  user_to_follow = User.find(params[:id])

  follow = Follow.find_or_initialize_by(
    follower: current_user,
    followed: user_to_follow
  )

  if follow.save
    render json: {
      following: follow.accepted?,
      requested: follow.pending?,
      status: follow.status,
      user_id: user_to_follow.id
    }, status: :created
  else
    render json: {
      errors: follow.errors.full_messages
    }, status: :unprocessable_entity
  end
end

  def destroy
  follow = Follow.find_by(
    follower: current_user,
    followed_id: params[:id]
  )

  follow&.destroy

  render json: {
    following: false,
    user_id: params[:id]
  }
end
end