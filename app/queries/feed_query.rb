class FeedQuery
  DEFAULT_PER_PAGE = 20

  def initialize(user:, page: 1, per_page: DEFAULT_PER_PAGE)
    @user = user
    @page = page
    @per_page = per_page
  end

  def call
    Post
      .visible_to(user)
      .includes(:user, :hashtags)
      .order(created_at: :desc)
      .page(page)
      .per(per_page)
  end

  private

  attr_reader :user, :page, :per_page
end