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

  after_commit :extract_hashtags, on: [:create, :update]
  after_commit :extract_mentions, on: [:create, :update]

  HASHTAG_REGEX = /#\w+/i
  MENTION_REGEX = /@\w+/i

  private

  def extract_hashtags
    tags = body.scan(HASHTAG_REGEX)
               .map { |tag| tag.delete("#").downcase }
               .uniq

    hashtags.clear

    tags.each do |tag_name|
      hashtag = Hashtag.find_or_create_by!(name: tag_name)

      post_hashtags.find_or_create_by!(hashtag: hashtag)
    end
  end

  def extract_mentions
    usernames = body.scan(MENTION_REGEX)
                    .map { |mention| mention.delete("@").downcase }
                    .uniq

    mentioned_users.clear

    usernames.each do |username|
      mentioned_user = User.find_by(username: username)

      next unless mentioned_user

      post_mentions.find_or_create_by!(user: mentioned_user)
    end
  end
end