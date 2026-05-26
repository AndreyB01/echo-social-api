class User < ApplicationRecord
  has_secure_password

  has_many :refresh_tokens,
           dependent: :destroy

  has_many :posts,
           dependent: :destroy

  has_many :likes,
           dependent: :destroy

  has_many :liked_posts,
           through: :likes,
           source: :post

  has_many :comments,
           dependent: :destroy

  has_many :post_mentions,
           dependent: :destroy

  has_many :mentioned_in_posts,
           through: :post_mentions,
           source: :post

  has_many :active_follows,
           class_name: "Follow",
           foreign_key: :follower_id,
           dependent: :destroy

  has_many :user_sessions, dependent: :destroy

  has_many :following,
           -> { where(follows: { status: :accepted }) },
           through: :active_follows,
           source: :followed

  has_many :passive_follows,
           class_name: "Follow",
           foreign_key: :followed_id,
           dependent: :destroy

  has_many :followers,
           -> { where(follows: { status: :accepted }) },
           through: :passive_follows,
           source: :follower

  has_many :notifications,
           dependent: :destroy

  has_many :active_notifications,
           class_name: "Notification",
           foreign_key: :actor_id,
           dependent: :destroy

  has_many :active_blocks,
           class_name: "Block",
           foreign_key: :blocker_id,
           dependent: :destroy

  has_many :blocked_users,
           through: :active_blocks,
           source: :blocked

  has_many :passive_blocks,
           class_name: "Block",
           foreign_key: :blocked_id,
           dependent: :destroy

  has_many :blockers,
           through: :passive_blocks,
           source: :blocker

  has_many :active_mutes,
           class_name: "Mute",
           foreign_key: :muter_id,
           dependent: :destroy

  has_many :muted_users,
           through: :active_mutes,
           source: :muted

  has_many :passive_mutes,
           class_name: "Mute",
           foreign_key: :muted_id,
           dependent: :destroy

  validates :email,
            presence: true,
            uniqueness: true

  validates :username,
            presence: true,
            uniqueness: true,
            length: { minimum: 3, maximum: 30 }

  validates :display_name,
            presence: true,
            length: { maximum: 50 }

  def following?(other_user)
    active_follows.exists?(followed: other_user, status: :accepted)
  end

  def pending_follow_request?(other_user)
    active_follows.exists?(followed: other_user, status: :pending)
  end
end