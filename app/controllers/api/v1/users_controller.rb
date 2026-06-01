class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def search
    query = params[:query].to_s.strip

    users = User
              .where("similarity(username, ?) > 0.2", query)
              .order(
                Arel.sql(
                  ActiveRecord::Base.sanitize_sql_array(
                    [
                      "similarity(username, ?) DESC",
                      query
                    ]
                  )
                )
              )
              .limit(10)

    render json: {
      data: users.map { |user| serialize_user(user) },
      meta: {},
      errors: []
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