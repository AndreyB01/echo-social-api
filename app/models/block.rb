class Block < ApplicationRecord
  belongs_to :blocker,
             class_name: "User"

  belongs_to :blocked,
             class_name: "User"

  validates :blocker_id,
            uniqueness: {
              scope: :blocked_id
            }

  validate :cannot_block_self

  private

  def cannot_block_self
    return unless blocker_id == blocked_id

    errors.add(:blocked_id, "cannot block yourself")
  end
end