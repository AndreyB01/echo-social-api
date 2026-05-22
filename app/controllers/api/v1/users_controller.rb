class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def search
    query = params[:query].to_s.downcase.strip

    users = User
              .where("LOWER(username) LIKE ?", "%#{query}%")
              .limit(10)

    render json: {
      data: users.map { |user| serialize_user(user) }
    }
  end

  private

  def serialize_user(user)
    {
      id: user.id,
      username: user.username,
      display_name: user.display_name
    }
  end
end