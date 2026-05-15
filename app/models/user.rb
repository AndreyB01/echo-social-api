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
       # Пользователи, которых я подписан
has_many :active_follows,
         class_name: "Follow",
         foreign_key: "follower_id",
         dependent: :destroy
has_many :following,
         through: :active_follows,
         source: :followed

# Пользователи, которые подписаны на меня
has_many :passive_follows,
         class_name: "Follow",
         foreign_key: "followed_id",
         dependent: :destroy
has_many :followers,
         through: :passive_follows,
         source: :follower

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
end