class Api::V1::FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    user_to_follow = User.find(params[:id])
    current_user.following << user_to_follow unless current_user.following.include?(user_to_follow)

    render json: { following: true, user_id: user_to_follow.id }
  end

  def destroy
    user_to_unfollow = User.find(params[:id])
    current_user.following.destroy(user_to_unfollow)

    render json: { following: false, user_id: user_to_unfollow.id }
  end
end