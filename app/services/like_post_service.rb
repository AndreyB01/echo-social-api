class LikePostService
  def initialize(user:, post:)
    @user = user
    @post = post
  end

  def call
    return existing_like if existing_like.present?

    create_like
  end

  private

  attr_reader :user, :post

  def existing_like
    @existing_like ||= Like.find_by(
      user:,
      post:
    )
  end

  def create_like
    like = Like.create!(
      user:,
      post:
    )

    create_notification(like)

    like
  end

  def create_notification(like)
    return if post.user == user

    Notification.create!(
      user: post.user,
      actor: user,
      notifiable: like,
      notification_type: "like"
    )
  end
end