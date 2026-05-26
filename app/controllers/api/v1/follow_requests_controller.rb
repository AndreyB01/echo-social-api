class Api::V1::FollowRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    requests = current_user
      .passive_follows
      .pending
      .includes(:follower)

    render_success(
    data: requests.map do |follow|
        {
        id: follow.id,
        follower: {
            id: follow.follower.id,
            username: follow.follower.username,
            display_name: follow.follower.display_name
        }
        }
    end
    )
  end
end