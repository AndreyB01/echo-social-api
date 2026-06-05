module Api
  module V1
    class SearchController < ApplicationController
      before_action :authenticate_user!

      DEFAULT_LIMIT = 20

      def index
        query = params[:q].to_s.strip
        limit = params[:limit]&.to_i || DEFAULT_LIMIT
        limit = DEFAULT_LIMIT if limit <= 0
        search_result = SearchQuery.new(query: query, current_user: current_user).call

        data = []

        search_result[:users].each do |user|
          data << {
            type: "user",
            id: user.id,
            attributes: {
              username: user.username,
              display_name: user.display_name,
              avatar_url: nil
            }
          }
        end

        search_result[:posts].each do |post|
          data << {
            type: "post",
            id: post.id,
            attributes: {
              content: post.body,
              created_at: post.created_at.iso8601,
              author: {
                id: post.user.id,
                username: post.user.username,
                display_name: post.user.display_name,
                avatar_url: nil
              },
              mentions: post.mentioned_users.map { |u| { id: u.id, username: u.username } },
              hashtags: post.hashtags.map { |h| { id: h.id, name: h.name } },
              likes_count: post.likes_count,
              comments_count: post.comments_count,
              liked_by_me: post.likes.exists?(user_id: current_user.id)
            }
          }
        end

        search_result[:hashtags].each do |hashtag|
          data << {
            type: "hashtag",
            id: hashtag.id,
            attributes: {
              name: hashtag.name,
              posts_count: hashtag.respond_to?(:posts_count) ? hashtag.posts_count : nil
            }
          }
        end

        paginated_data = data.first(limit)
        has_next = data.size > limit

        render json: {
          data: paginated_data,
          meta: {
            next_cursor: nil,
            limit: limit,
            has_next: has_next
          }
        }, status: :ok
      end
    end
  end
end