require "swagger_helper"
require "digest"

RSpec.describe "Auth Refresh API", type: :request do
  path "/api/v1/auth/refresh" do
    post "Refresh access token" do
      tags "Auth"

      consumes "application/json"
      produces "application/json"

      parameter name: :refresh_token,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    refresh_token: {
                      type: :string,
                      example: "refresh_token_value"
                    }
                  },
                  required: ["refresh_token"]
                }

      response "200", "token refreshed" do
        let(:user) { create(:user) }

        let(:raw_refresh_token) { "valid_refresh_token" }

        let!(:user_session) do
          UserSession.create!(
            user: user,
            refresh_token_digest: Digest::SHA256.hexdigest(raw_refresh_token),
            expires_at: 30.days.from_now
          )
        end

        let(:refresh_token) do
          { refresh_token: raw_refresh_token }
        end

        example "application/json", :success_response, {
          access_token: "new_access_token",
          refresh_token: "new_refresh_token",
          token_type: "Bearer"
        }

        run_test!
      end

      response "401", "invalid refresh token" do
        let(:refresh_token) { { refresh_token: "invalid_refresh_token" } }

        example "application/json", :invalid_token, {
          error: "Invalid refresh token"
        }

        run_test!
      end
    end
  end
end