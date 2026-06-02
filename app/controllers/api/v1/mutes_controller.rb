class Api::V1::MutesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    mute = Mute.find_or_create_by!(muter: current_user, muted: @user)

    render_success(
      data: { muted: true, user_id: @user.id },
      status: :created
    )
  end

  def destroy
    mute = Mute.find_by(muter: current_user, muted: @user)
    mute&.destroy

    render_success(
      data: { muted: false, user_id: @user.id }
    )
  end

  private

  def set_user
    @user = User.find_by!(username: params[:username])
  end
end