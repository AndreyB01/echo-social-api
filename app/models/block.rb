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

  after_create_commit :remove_follow_relationships

  private

  def cannot_block_self
    return unless blocker_id == blocked_id

    errors.add(:blocked_id, "cannot block yourself")
  end

  def remove_follow_relationships
    Follow.where(
      follower: blocker,
      followed: blocked
    ).or(
      Follow.where(
        follower: blocked,
        followed: blocker
      )
    ).destroy_all
  end
end