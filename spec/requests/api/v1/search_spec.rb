require "rails_helper"

RSpec.describe "Search API", type: :request do
describe "GET /api/v1/search" do
let(:user) do
create(
:user,
username: "tester",
password: "password"
)
end

let!(:post) do
  create(
    :post,
    user: user,
    body: "I love Rails"
  )
end

let!(:hashtag) do
  create(:hashtag, name: "rails")
end

let(:token) do
  Jwt::Encoder.call(user_id: user.id)
end

let(:headers) do
  {
    "Authorization" => "Bearer #{token}"
  }
end

it "returns users, posts and hashtags" do
  get "/api/v1/search",
      params: { query: "rails" },
      headers: headers

  expect(response).to have_http_status(:ok)

  json = JSON.parse(response.body)

  expect(json["data"]).to have_key("users")
  expect(json["data"]).to have_key("posts")
  expect(json["data"]).to have_key("hashtags")
end

end
end