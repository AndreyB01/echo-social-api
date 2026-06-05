require "rails_helper"

RSpec.describe "Posts API", type: :request do
  let!(:user) { create(:user) }
  let!(:posts) { create_list(:post, 3, user: user) }

  let(:token) do
    auth_token_for(user)
  end

  let(:headers) do
    {
      "Authorization" => "Bearer #{token}"
    }
  end
end
