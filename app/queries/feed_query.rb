class FeedQuery
  DEFAULT_LIMIT = 20

  def initialize(user:, cursor: nil, limit: DEFAULT_LIMIT)
    @user = user
    @cursor = cursor
    @limit = limit
  end

  def call
    Pagination::CursorPaginator.new(
      Post.visible_to(user)
          .includes(:user, :hashtags),
      cursor: cursor,
      limit: limit
    ).call
  end

  private

  attr_reader :user, :cursor, :limit
end