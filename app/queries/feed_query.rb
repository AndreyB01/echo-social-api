class FeedQuery
  DEFAULT_LIMIT = 20

  def initialize(user:, cursor: nil, limit: DEFAULT_LIMIT)
    @user = user
    @cursor = cursor
    @limit = limit
  end

  def call
    FeedCacheService.fetch(
      user_id: user.id,
      cursor: cursor
    ) do
      result = Pagination::CursorPaginator.new(
        Post.visible_to(user)
            .includes(:user, :hashtags)
            .order(created_at: :desc),
        cursor: cursor,
        limit: limit
      ).call

      {
        records: serialize_records(result[:records]),
        meta: result[:meta]
      }
    end
  end

  private

  attr_reader :user, :cursor, :limit

  def serialize_records(records)
    records.map do |post|
      PostSerializer.new(post).as_json
    end
  end
end