class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  MAX_IMAGES = 4
  MAX_IMAGE_SIZE = 5.megabytes
  ALLOWED_IMAGE_TYPES = %w[
    image/jpeg
    image/png
    image/webp
  ].freeze

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

  validate :validate_images

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  scope :visible_to, ->(user) {
    blocker_user_ids =
      Block.where(blocked_id: user.id)
           .select(:blocker_id)

    blocked_user_ids =
      Block.where(blocker_id: user.id)
           .select(:blocked_id)

    muted_user_ids =
      Mute.where(muter_id: user.id)
          .select(:muted_id)

    visible_user_ids =
      User
        .left_joins(:passive_follows)
        .where(
          <<~SQL,
            users.is_private = :public
            OR users.id = :current_user_id
            OR (
              follows.follower_id = :current_user_id
              AND follows.status = :accepted
            )
          SQL
          public: false,
          current_user_id: user.id,
          accepted: Follow.statuses[:accepted]
        )
        .where.not(id: blocker_user_ids)
        .where.not(id: blocked_user_ids)
        .where.not(id: muted_user_ids)
        .distinct
        .select(:id)

    where(user_id: visible_user_ids).active
  }

  after_create_commit :broadcast_to_feed
  after_create_commit :broadcast_post
  after_commit :enqueue_content_parsing, on: %i[create update]

  def soft_delete!
    update!(deleted_at: Time.current)
  end

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

  def validate_images
    return unless images.attached?

    if images.count > MAX_IMAGES
      errors.add(:images, "maximum is 4 images")
    end

    images.each do |image|
      unless ALLOWED_IMAGE_TYPES.include?(image.content_type)
        errors.add(:images, "must be JPEG, PNG, or WEBP")
      end

      if image.byte_size > MAX_IMAGE_SIZE
        errors.add(:images, "size must be less than 5MB")
      end
    end
  end
end