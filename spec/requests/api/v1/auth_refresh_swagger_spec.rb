require "swagger_helper"

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
        example "application/json", :success_response, {
          access_token: "new_access_token",
          refresh_token: "new_refresh_token",
          token_type: "Bearer"
        }

        run_test!
      end

      response "401", "invalid refresh token" do
        example "application/json", :invalid_token, {
          error: "Invalid refresh token"
        }

        run_test!
      end
    end
  end
end
