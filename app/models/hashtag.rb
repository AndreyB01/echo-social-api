class Hashtag < ApplicationRecord
  has_many :post_hashtags, dependent: :destroy
  has_many :posts, through: :post_hashtags

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false }

  before_validation :normalize_name

  private

  def normalize_name
    self.name = name.to_s.downcase.strip
  end
end