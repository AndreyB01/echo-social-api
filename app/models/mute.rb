class Mute < ApplicationRecord
  belongs_to :muter, class_name: "User"
  belongs_to :muted, class_name: "User"

  validates :muter_id,
            uniqueness: {
              scope: :muted_id
            }

  validate :cannot_mute_self

  private

  def cannot_mute_self
    return unless muter_id == muted_id

    errors.add(:muted_id, "cannot mute yourself")
  end
end