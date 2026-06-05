class Api::V1::BlocksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    block = Block.find_or_create_by!(
      blocker: current_user,
      blocked: @user
    )

    render_success(
      data: {
        blocked: true,
        user_id: @user.id
      },
      status: :created
    )
  end

  def destroy
    block = Block.find_by(
      blocker: current_user,
      blocked: @user
    )

    block&.destroy

    render_success(
      data: {
        blocked: false,
        user_id: @user.id
      }
    )
  end

  private

  def set_user
    @user = User.find_by!(
      username: params[:username]
    )
  end
end