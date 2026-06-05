class SearchQuery
  LIMIT = 10

  def initialize(query:, current_user:)
    @query = query.to_s.downcase.strip
    @current_user = current_user
  end

  def call
    {
      users: search_users,
      hashtags: search_hashtags,
      posts: search_posts
    }
  end

  private

  attr_reader :query, :current_user

  def search_users
    User
      .where(
        "LOWER(username) LIKE :q OR LOWER(display_name) LIKE :q",
        q: "%#{query}%"
      )
      .limit(LIMIT)
  end

  def search_hashtags
    Hashtag
      .where("LOWER(name) LIKE ?", "%#{query}%")
      .limit(LIMIT)
  end

  def search_posts
    Post
      .visible_to(current_user)
      .includes(:user)
      .where("LOWER(body) LIKE ?", "%#{query}%")
      .order(created_at: :desc)
      .limit(LIMIT)
  end
end