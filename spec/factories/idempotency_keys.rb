FactoryBot.define do
  factory :idempotency_key do
    key { "MyString" }
    user { nil }
    response_status { "MyString" }
    response_body { "" }
  end
end
