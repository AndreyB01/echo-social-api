class Notification < ApplicationRecord
  belongs_to :user

  belongs_to :actor,
             class_name: "User"

  belongs_to :notifiable,
             polymorphic: true

  TYPES = %w[
    like
    comment
    follow
    mention
  ].freeze

  validates :notification_type,
            presence: true,
            inclusion: { in: TYPES }
end