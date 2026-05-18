FactoryBot.define do
  factory :notification do
    association :user
    association :actor,
                factory: :user

    association :notifiable,
                factory: :post

    notification_type { "like" }

    read_at { nil }
  end
end