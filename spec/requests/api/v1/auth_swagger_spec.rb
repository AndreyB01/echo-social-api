require "swagger_helper"
require "digest"

RSpec.describe "Auth API", type: :request do
  path "/api/v1/auth/register" do
    post "Register user" do
      tags "Auth"

      consumes "application/json"
      produces "application/json"

      parameter name: :user,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    user: {
                      type: :object,
                      properties: {
                        email: { type: :string, example: "john@example.com" },
                        username: { type: :string, example: "john_doe" },
                        password: { type: :string, example: "password123" },
                        password_confirmation: {
                          type: :string,
                          example: "password123"
                        }
                      },
                      required: %w[email username password password_confirmation]
                    }
                  }
                }

      response "201", "user created" do
        let(:user) do
          {
            user: {
              email: "john@example.com",
              username: "john_doe",
              display_name: "John Doe",
              password: "password123",
              password_confirmation: "password123"
            }
          }
        end

        example "application/json", :success_response, {
          data: {
            id: 1,
            type: "user",
            attributes: {
              email: "john@example.com",
              username: "john_doe",
              display_name: nil,
              bio: nil,
              created_at: "2026-05-29T12:00:00Z"
            }
          },
          meta: {},
          errors: []
        }

        run_test!
      end

      response "422", "validation failed" do
        schema ValidationErrorSchema

        let(:user) do
          {
            user: {
              email: "",
              username: "",
              password: "123",
              password_confirmation: "456"
            }
          }
        end

        example "application/json", :validation_error, {
          errors: [
            "Email has already been taken",
            "Password is too short (minimum is 8 characters)"
          ]
        }

        run_test!
      end
    end
  end

  path "/api/v1/auth/login" do
    post "Login user" do
      tags "Auth"

      consumes "application/json"
      produces "application/json"

      parameter name: :user,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    user: {
                      type: :object,
                      properties: {
                        email: {
                          type: :string,
                          example: "john@example.com"
                        },
                        password: {
                          type: :string,
                          example: "password123"
                        }
                      },
                      required: %w[email password]
                    }
                  }
                }

      response "200", "login success" do
        let!(:existing_user) do
          create(
            :user,
            email: "john@example.com",
            password: "password123",
            password_confirmation: "password123",
            confirmed_at: Time.current
          )
        end

        let(:user) do
          {
            user: {
              email: "john@example.com",
              password: "password123"
            }
          }
        end

        example "application/json", :success_response, {
          data: {
            access_token: "jwt_access_token",
            refresh_token: "jwt_refresh_token",
            token_type: "Bearer"
          },
          meta: {},
          errors: []
        }

        run_test!
      end

      response "401", "invalid credentials" do
        schema ErrorSchema

        let(:user) do
          {
            user: {
              email: "wrong@example.com",
              password: "wrongpassword"
            }
          }
        end

        example "application/json", :invalid_credentials, {
          error: "Invalid credentials"
        }

        run_test!
      end
    end
  end

  path "/api/v1/auth/logout" do
    delete "Logout user" do
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
                  required: %w[refresh_token]
                }

      response "200", "logout success" do
        let(:user) { create(:user) }
        let(:raw_refresh_token) { "valid_refresh_token" }
        let!(:user_session) do
          UserSession.create!(
            user: user,
            refresh_token_digest: Digest::SHA256.hexdigest(raw_refresh_token),
            expires_at: 30.days.from_now,
            user_agent: "Rswag test",
            ip_address: "127.0.0.1"
          )
        end
        let(:refresh_token) { { refresh_token: raw_refresh_token } }

        example "application/json", :success_response, {
          message: "Logged out successfully"
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