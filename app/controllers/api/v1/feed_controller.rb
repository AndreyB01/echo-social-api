class Api::V1::FeedController < ApplicationController
  def index
    limit = params.fetch(:limit, 20).to_i.clamp(1, 100)
    cursor = params[:cursor]

    posts_query = Post
      .includes(
        :user,
        :hashtags,
        :likes,
        :comments
      )
      .order(id: :desc)

    if cursor.present?
      posts_query = posts_query.where("id < ?", cursor.to_i)
    end

    posts = posts_query.limit(limit + 1).to_a

    has_next_page = posts.length > limit

    posts = posts.first(limit)

    next_cursor =
      if has_next_page
        posts.last.id
      end

    render json: {
      data: posts.map { |post| serialize_post(post) },
      meta: {
        limit: limit,
        next_cursor: next_cursor,
        has_next_page: has_next_page
      }
    }
  end

  private

  def serialize_post(post)
    {
      id: post.id,
      body: post.body,
      created_at: post.created_at,

      likes_count: post.likes.size,
      comments_count: post.comments.size,

      hashtags: post.hashtags.map(&:name),

      author: {
        id: post.user.id,
        username: post.user.username,
        display_name: post.user.display_name
      }
    }
  end
end