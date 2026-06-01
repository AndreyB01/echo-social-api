class Api::V1::BlocksController < ApplicationController
  before_action :authenticate_user!

  def create
    user_to_block = User.find(params[:id])

    block = Block.find_or_initialize_by(
      blocker: current_user,
      blocked: user_to_block
    )

    if block.save
      render_success(
        data: {
          blocked: true,
          user_id: user_to_block.id
        },
        status: :created
      )
    else
      render_validation_error(block)
    end
  end

  def destroy
    block = Block.find_by(
      blocker: current_user,
      blocked_id: params[:id]
    )

    block&.destroy

    render_success(
      data: {
        blocked: false,
        user_id: params[:id].to_i
      }
    )
  end
end