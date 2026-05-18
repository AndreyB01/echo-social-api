FactoryBot.define do
  factory :comment do
    association :user
    association :post

    body { "Test comment" }
  end
end