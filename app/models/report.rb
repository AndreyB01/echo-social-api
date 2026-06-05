class Report < ApplicationRecord
  belongs_to :reporter,
             class_name: "User"

  belongs_to :reportable,
             polymorphic: true

  enum :status,
       {
         pending: "pending",
         resolved: "resolved"
       }

  validates :reason,
            presence: true
end