class Api::V1::HashtagsController < ApplicationController
  def posts
    hashtag = Hashtag.find_by!(name: params[:tag].downcase)

    posts = hashtag.posts
                   .includes(:user, :hashtags)
                   .order(created_at: :desc)

    render json: {
      data: posts.map { |post| serialize_post(post) }
    }
  end

  private

  def serialize_post(post)
    {
      id: post.id,
      body: post.body,
      created_at: post.created_at,
      hashtags: post.hashtags.pluck(:name),
      author: {
        id: post.user.id,
        username: post.user.username,
        display_name: post.user.display_name
      }
    }
  end
end