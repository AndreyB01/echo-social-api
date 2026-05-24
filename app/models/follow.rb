class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  enum status: {
    pending: 0,
    accepted: 1,
    rejected: 2
  }

  scope :pending_requests, -> { pending }
  scope :accepted_requests, -> { accepted }

  before_validation :set_initial_status, on: :create

  validates :follower_id,
            uniqueness: {
              scope: :followed_id
            }

  validate :cannot_follow_self

  private

  def cannot_follow_self
    return unless follower_id == followed_id

    errors.add(:followed_id, "cannot follow yourself")
  end

  def set_initial_status
    return if status.present?

    self.status =
      if followed.nil?
        :accepted
      elsif followed.is_private?
        :pending
      else
        :accepted
      end
  end
end