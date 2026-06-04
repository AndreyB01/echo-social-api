FactoryBot.define do
  factory :report do
    association :reporter, factory: :user

    reportable_type { "Post" }
    reportable_id { create(:post).id }

    reason { "Spam" }

    status { "pending" }
  end
end