class Api::V1::FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    user_to_follow = User.find(params[:id])

    follow = Follow.find_or_initialize_by(
      follower: current_user,
      followed: user_to_follow
    )

    if follow.save
      render_success(
        data: {
          following: follow.accepted?,
          requested: follow.pending?,
          status: follow.status,
          user_id: user_to_follow.id
        },
        status: :created
      )
    else
      render_validation_error(follow)
    end
  end

  def destroy
    follow = Follow.find_by(
      follower: current_user,
      followed_id: params[:id]
    )

    follow&.destroy

    render_success(
      data: {
        following: false,
        user_id: params[:id]
      }
    )
  end

  def accept
    follow = Follow.find_by!(
      follower_id: params[:id],
      followed: current_user,
      status: :pending
    )

    follow.update!(status: :accepted)

    render_success(
      data: {
        status: follow.status,
        user_id: follow.follower_id
      }
    )
  end

  def reject
    follow = Follow.find_by!(
      follower_id: params[:id],
      followed: current_user,
      status: :pending
    )

    follow.update!(status: :rejected)

    render_success(
      data: {
        status: follow.status,
        user_id: follow.follower_id
      }
    )
  end
end