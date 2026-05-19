class FeedQuery
  def initialize(user:)
    @user = user
  end

  def call
    Post
      .includes(:user, :hashtags)
      .where(user_id: feed_user_ids)
      .order(created_at: :desc)
  end

  private

  attr_reader :user

  def feed_user_ids
    user
      .following
      .pluck(:id) + [user.id]
  end
end