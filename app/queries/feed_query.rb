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
      Pagination::CursorPaginator.new(
        Post.active
            .visible_to(user)
            .includes(:user, :hashtags, images_attachments: :blob)
            .order(created_at: :desc),
        cursor: cursor,
        limit: limit
      ).call
    end
  end

  private

  attr_reader :user, :cursor, :limit
end