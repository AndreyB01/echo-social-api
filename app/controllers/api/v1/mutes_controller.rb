class Api::V1::MutesController < ApplicationController
  before_action :authenticate_user!

  def create
    user_to_mute = User.find(params[:id])

    mute = Mute.find_or_create_by!(
      muter: current_user,
      muted: user_to_mute
    )

    render_success(
      data: {
        muted: true,
        user_id: mute.muted_id
      },
      status: :created
    )
  end

  def destroy
    mute = Mute.find_by(
      muter: current_user,
      muted_id: params[:id]
    )

    mute&.destroy

    render_success(
      data: {
        muted: false,
        user_id: params[:id].to_i
      }
    )
  end
end