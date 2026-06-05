class Api::V1::FollowRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_follow_request, only: %i[accept reject]

  def index
    pending_requests = Follow.where(followed_id: current_user.id, status: :pending)
    data = pending_requests.map do |follow|
      {
        id: follow.id,
        follower: {
          id: follow.follower.id,
          username: follow.follower.username,
          display_name: follow.follower.display_name
        }
      }
    end
    render json: {
      data: data,
      meta: {
        next_cursor: nil,
        limit: data.size,
        has_next: false
      },
      errors: []
    }, status: :ok
  end

  def accept
    if @follow_request.pending?
      @follow_request.update!(status: :accepted)
      render json: { message: "Follow request accepted" }, status: :ok
    else
      render json: { error: "Cannot accept" }, status: :unprocessable_entity
    end
  end

  def reject
    if @follow_request.pending?
      @follow_request.destroy!
      render json: { message: "Follow request rejected" }, status: :ok
    else
      render json: { error: "Cannot reject" }, status: :unprocessable_entity
    end
  end

  private

  def set_follow_request
    @follow_request = Follow.find(params[:id])
    unless @follow_request.followed_id == current_user.id
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end
end