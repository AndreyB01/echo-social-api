require "swagger_helper"

RSpec.describe "Users API", type: :request do
  path "/api/v1/users/{username}" do
    parameter name: :username, in: :path, type: :string, required: true

    get "Get user profile" do
      tags "Users"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "200", "user profile found" do
        let(:user) { create(:user, username: "john_doe") }
        let(:Authorization) { "Bearer #{auth_token_for(user)}" }
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
        let(:Authorization) { "Bearer #{auth_token_for(current_user)}" }
        let(:username) { "unknown" }

        example "application/json", :not_found, {
          error: "User not found"
        }

        run_test!
      end
    end
  end

  path "/api/v1/users/{username}/posts" do
    parameter name: :username, in: :path, type: :string, required: true
    parameter name: :cursor, in: :query, type: :string, required: false, description: "Pagination cursor"
    parameter name: :limit, in: :query, type: :integer, required: false, description: "Items per page (default 20, max 50)"

    get "List user posts" do
      tags "Users"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "200", "posts found" do
        let(:user) { create(:user, username: "john_doe") }
        let(:Authorization) { "Bearer #{auth_token_for(user)}" }
        let(:username) { user.username }

        schema BaseResponseSchema.call(
          data_schema: {
            type: :array,
            items: PostSchema
          },
          meta_schema: PaginationMetaSchema
        )

        example "application/json", :success_response, {
          data: [
            {
              id: 1,
              body: "Hello world",
              created_at: "2026-06-02T12:00:00Z",
              likes_count: 5,
              comments_count: 2,
              hashtags: [],
              author: { id: 1, username: "john_doe" }
            }
          ],
          meta: {
            next_cursor: nil,
            limit: 20,
            has_next: false
          },
          errors: []
        }

        run_test!
      end
    end
  end

  path "/api/v1/users/{username}/followers" do
    parameter name: :username, in: :path, type: :string, required: true
    parameter name: :cursor, in: :query, type: :string, required: false, description: "Pagination cursor"
    parameter name: :limit, in: :query, type: :integer, required: false, description: "Items per page (default 20, max 50)"

    get "List user followers" do
      tags "Users"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "200", "followers found" do
        let(:user) { create(:user, username: "john_doe") }
        let(:Authorization) { "Bearer #{auth_token_for(user)}" }
        let(:username) { user.username }

        schema BaseResponseSchema.call(
          data_schema: {
            type: :array,
            items: UserSchema
          },
          meta_schema: PaginationMetaSchema
        )

        example "application/json", :success_response, {
          data: [
            { id: 2, username: "alice", display_name: "Alice" }
          ],
          meta: {
            next_cursor: nil,
            limit: 20,
            has_next: false
          },
          errors: []
        }

        run_test!
      end
    end
  end

  path "/api/v1/users/{username}/following" do
    parameter name: :username, in: :path, type: :string, required: true
    parameter name: :cursor, in: :query, type: :string, required: false, description: "Pagination cursor"
    parameter name: :limit, in: :query, type: :integer, required: false, description: "Items per page (default 20, max 50)"

    get "List user following" do
      tags "Users"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "200", "following found" do
        let(:user) { create(:user, username: "john_doe") }
        let(:Authorization) { "Bearer #{auth_token_for(user)}" }
        let(:username) { user.username }

        schema BaseResponseSchema.call(
          data_schema: {
            type: :array,
            items: UserSchema
          },
          meta_schema: PaginationMetaSchema
        )

        example "application/json", :success_response, {
          data: [
            { id: 3, username: "bob", display_name: "Bob" }
          ],
          meta: {
            next_cursor: nil,
            limit: 20,
            has_next: false
          },
          errors: []
        }

        run_test!
      end
    end
  end

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
        let(:Authorization) { "Bearer #{auth_token_for(current_user)}" }
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

    delete "Unfollow user" do
      tags "Users"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: :username, in: :path, schema: { type: :string }

      response "200", "user unfollowed" do
        let(:current_user) { create(:user) }
        let(:target_user) { create(:user) }
        let(:Authorization) { "Bearer #{auth_token_for(current_user)}" }
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

  path "/api/v1/users/{username}/block" do
    parameter name: :username, in: :path, type: :string

    post "Block user" do
      tags "Users"
      security [ bearerAuth: [] ]
      produces "application/json"

      response "201", "user blocked" do
        let(:current_user) { create(:user) }
        let(:target_user) { create(:user) }
        let(:Authorization) { "Bearer #{auth_token_for(current_user)}" }
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

    delete "Unblock user" do
      tags "Users"
      security [ bearerAuth: [] ]
      produces "application/json"

      response "200", "user unblocked" do
        let(:current_user) { create(:user) }
        let(:target_user) { create(:user) }
        let(:Authorization) { "Bearer #{auth_token_for(current_user)}" }
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
        let(:Authorization) { "Bearer #{auth_token_for(current_user)}" }

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

    delete "Unmute user" do
      tags "Users"
      security [ bearerAuth: [] ]
      produces "application/json"

      response "200", "user unmuted" do
        let(:current_user) { create(:user) }
        let(:target_user) { create(:user) }
        let(:username) { target_user.username }
        let(:Authorization) { "Bearer #{auth_token_for(current_user)}" }

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