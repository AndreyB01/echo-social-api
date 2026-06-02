class Api::V1::FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    follow = Follow.find_or_initialize_by(follower: current_user, followed: @user)

    if follow.save
      render_success(
        data: {
          following: follow.accepted?,
          requested: follow.pending?,
          status: follow.status,
          user_id: @user.id
        },
        status: :created
      )
    else
      render_validation_error(follow)
    end
  end

  def destroy
    follow = Follow.find_by(follower: current_user, followed: @user)
    follow&.destroy

    render_success(
      data: {
        following: false,
        user_id: @user.id
      }
    )
  end

  private

  def set_user
    @user = User.find_by!(username: params[:username])
  end
end