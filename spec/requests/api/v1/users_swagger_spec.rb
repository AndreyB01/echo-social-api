require "swagger_helper"

RSpec.describe "Users API", type: :request do
  # 1. GET /users/:username
  path "/api/v1/users/{username}" do
    parameter name: :username, in: :path, type: :string, required: true

    get "Get user profile" do
      tags "Users"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "200", "user profile found" do
        let(:user) { create(:user, username: "john_doe") }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: user.id)}" }
        let(:username) { user.username }

        example "application/json", :success_response, {
          data: {
            id: 1,
            username: "john_doe",
            display_name: "John Doe",
            bio: "Ruby developer"
          },
          meta: {},
          errors: []
        }

        run_test!
      end

      response "404", "user not found" do
        let(:current_user) { create(:user) }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: current_user.id)}" }
        let(:username) { "unknown" }

        example "application/json", :not_found, {
          error: "User not found"
        }

        run_test!
      end
    end
  end

  # 2. GET /users/:username/posts
  path "/api/v1/users/{username}/posts" do
    parameter name: :username, in: :path, type: :string, required: true

    get "List user posts" do
      tags "Users"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "200", "posts found" do
        let(:user) { create(:user, username: "john_doe") }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: user.id)}" }
        let(:username) { user.username }

        example "application/json", :success_response, {
          data: [
            {
              id: 1,
              body: "Hello world",
              created_at: "2026-06-02T12:00:00Z",
              likes_count: 5,
              comments_count: 2
            }
          ],
          meta: {},
          errors: []
        }

        run_test!
      end
    end
  end

  # 3. GET /users/:username/followers
  path "/api/v1/users/{username}/followers" do
    parameter name: :username, in: :path, type: :string, required: true

    get "List user followers" do
      tags "Users"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "200", "followers found" do
        let(:user) { create(:user, username: "john_doe") }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: user.id)}" }
        let(:username) { user.username }

        example "application/json", :success_response, {
          data: [
            { id: 2, username: "alice", display_name: "Alice" }
          ],
          meta: {},
          errors: []
        }

        run_test!
      end
    end
  end

  # 4. GET /users/:username/following
  path "/api/v1/users/{username}/following" do
    parameter name: :username, in: :path, type: :string, required: true

    get "List user following" do
      tags "Users"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "200", "following found" do
        let(:user) { create(:user, username: "john_doe") }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: user.id)}" }
        let(:username) { user.username }

        example "application/json", :success_response, {
          data: [
            { id: 3, username: "bob", display_name: "Bob" }
          ],
          meta: {},
          errors: []
        }

        run_test!
      end
    end
  end

  # 5. POST /users/:username/follow
  path "/api/v1/users/{username}/follow" do
    parameter name: :username, in: :path, schema: { type: :string }

    post "Follow user" do
      tags "Users"
      consumes "application/json"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "201", "follow created" do
        let(:current_user) { create(:user) }
        let(:target_user) { create(:user) }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: current_user.id)}" }
        let(:username) { target_user.username }

        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              following: { type: :boolean },
              requested: { type: :boolean },
              status: { type: :string },
              user_id: { type: :integer }
            }
          }
        )

        run_test!
      end
    end

    # 6. DELETE /users/:username/follow
    delete "Unfollow user" do
      tags "Users"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: :username, in: :path, schema: { type: :string }

      response "200", "user unfollowed" do
        let(:current_user) { create(:user) }
        let(:target_user) { create(:user) }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: current_user.id)}" }
        let(:username) { target_user.username }

        before do
          Follow.create!(
            follower: current_user,
            followed: target_user,
            status: :accepted
          )
        end

        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              following: { type: :boolean },
              user_id: { type: :integer }
            }
          }
        )

        run_test!
      end
    end
  end

  # 7. POST /users/:username/block
  path "/api/v1/users/{username}/block" do
    parameter name: :username, in: :path, type: :string

    post "Block user" do
      tags "Users"
      security [ bearerAuth: [] ]
      produces "application/json"

      response "201", "user blocked" do
        let(:current_user) { create(:user) }
        let(:target_user) { create(:user) }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: current_user.id)}" }
        let(:username) { target_user.username }

        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              blocked: { type: :boolean },
              user_id: { type: :integer }
            }
          }
        )

        run_test!
      end
    end

    # 8. DELETE /users/:username/block
    delete "Unblock user" do
      tags "Users"
      security [ bearerAuth: [] ]
      produces "application/json"

      response "200", "user unblocked" do
        let(:current_user) { create(:user) }
        let(:target_user) { create(:user) }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: current_user.id)}" }
        let(:username) { target_user.username }

        before do
          Block.create!(blocker: current_user, blocked: target_user)
        end

        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              blocked: { type: :boolean },
              user_id: { type: :integer }
            }
          }
        )

        run_test!
      end
    end
  end

  # 9. POST /users/:username/mute
  path "/api/v1/users/{username}/mute" do
    parameter name: :username, in: :path, schema: { type: :string }

    post "Mute user" do
      tags "Users"
      security [ bearerAuth: [] ]
      produces "application/json"

      response "201", "user muted" do
        let(:current_user) { create(:user) }
        let(:target_user) { create(:user) }
        let(:username) { target_user.username }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: current_user.id)}" }

        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              muted: { type: :boolean },
              user_id: { type: :integer }
            }
          }
        )

        run_test!
      end
    end

    # 10. DELETE /users/:username/mute
    delete "Unmute user" do
      tags "Users"
      security [ bearerAuth: [] ]
      produces "application/json"

      response "200", "user unmuted" do
        let(:current_user) { create(:user) }
        let(:target_user) { create(:user) }
        let(:username) { target_user.username }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: current_user.id)}" }

        before do
          Mute.create!(muter: current_user, muted: target_user)
        end

        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              muted: { type: :boolean },
              user_id: { type: :integer }
            }
          }
        )

        run_test!
      end
    end
  end
end