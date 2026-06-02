class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show posts followers following]
  before_action :authenticate_user!, only: %i[followers following search] # Опционально, можно убрать followers/following для гостей

  def show
    render_success(data: UserSerializer.render(@user))
  end

  def posts
    render_success(data: PostSerializer.render_collection(@user.posts.order(created_at: :desc)))
  end

  def followers
    render_success(data: UserSerializer.render_collection(@user.followers))
  end

  def following
    render_success(data: UserSerializer.render_collection(@user.following))
  end

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

    render_success(data: UserSerializer.render_collection(users))
  end

  private

  def set_user
    @user = User.find_by!(username: params[:username])
  end
end