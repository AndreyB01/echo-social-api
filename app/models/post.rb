class Post < ApplicationRecord
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user

  has_many :comments, dependent: :destroy

  has_many :post_hashtags, dependent: :destroy
  has_many :hashtags, through: :post_hashtags

  has_many :post_mentions, dependent: :destroy
  has_many :mentioned_users, through: :post_mentions, source: :user

  validates :body,
            presence: true,
            length: { maximum: 280 }

  scope :visible_to, ->(user) {
    blocker_user_ids =
      Block.where(blocked_id: user.id)
           .select(:blocker_id)

    blocked_user_ids =
      Block.where(blocker_id: user.id)
           .select(:blocked_id)

    visible_user_ids =
      User
        .left_joins(:passive_follows)
        .where(
          "users.is_private = :public
          OR users.id = :current_user_id
          OR (
            follows.follower_id = :current_user_id
            AND follows.status = :accepted
          )",
          public: false,
          current_user_id: user.id,
          accepted: Follow.statuses[:accepted]
        )
        .where.not(id: blocker_user_ids)
        .where.not(id: blocked_user_ids)
        .distinct
        .select(:id)

    where(user_id: visible_user_ids)
  }

  after_create_commit :broadcast_to_feed
  after_create_commit :broadcast_post
  after_commit :enqueue_content_parsing, on: %i[create update]

  private

  def enqueue_content_parsing
    ParsePostContentJob.perform_later(id)
  end

  def broadcast_to_feed
    BroadcastFeedJob.perform_later(self)
  end

  def broadcast_post
    BroadcastPostJob.perform_later(post: self)
  end
end