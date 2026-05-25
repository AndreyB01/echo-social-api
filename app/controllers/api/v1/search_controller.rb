module Api
module V1
class SearchController < ApplicationController
before_action :authenticate_user!

  def index
    Current.user = current_user
    results = SearchQuery.new(query: params[:query]).call

    render json: {
      data: {
        users: serialize_users(results[:users]),
        hashtags: serialize_hashtags(results[:hashtags]),
        posts: serialize_posts(results[:posts])
      }
    }
  end

  private

  def serialize_users(users)
    users.map do |user|
      {
        id: user.id,
        username: user.username,
        display_name: user.display_name
      }
    end
  end

  def serialize_hashtags(hashtags)
    hashtags.map do |hashtag|
      {
        id: hashtag.id,
        name: hashtag.name
      }
    end
  end

  def serialize_posts(posts)
    posts.map do |post|
      {
        id: post.id,
        body: post.body,
        created_at: post.created_at,
        author: {
          id: post.user.id,
          username: post.user.username
        }
      }
    end
  end
end

end
end