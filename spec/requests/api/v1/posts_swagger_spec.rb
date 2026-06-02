require "swagger_helper"

RSpec.describe "Posts API", type: :request do
  # 1. Создание поста
  path "/api/v1/posts" do
    post "Create post" do
      tags "Posts"
      consumes "application/json"
      produces "application/json"
      security [ bearerAuth: [] ]
      description "Create a new post. Idempotency key is required."

      parameter name: :"Idempotency-Key",
                in: :header,
                type: :string,
                required: true,
                description: "UUID v4 for idempotency"

      parameter name: :post,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    post: {
                      type: :object,
                      properties: {
                        content: { type: :string, example: "Hello #world @alice", description: "1-500 characters" },
                        image_id: { type: :string, nullable: true, description: "Signed blob ID for image" }
                      },
                      required: ["content"]
                    }
                  }
                }

      response "201", "post created" do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: user.id)}" }
        let(:'Idempotency-Key') { SecureRandom.uuid }
        let(:post) { { post: { content: "My first post" } } }

        schema BaseResponseSchema.call(data_schema: PostSchema)

        run_test!
      end

      response "422", "validation failed" do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: user.id)}" }
        let(:'Idempotency-Key') { SecureRandom.uuid }
        let(:post) { { post: { content: "" } } }

        run_test!
      end
    end
  end

  # 2. Просмотр поста
  path "/api/v1/posts/{id}" do
    parameter name: :id, in: :path, type: :integer, required: true

    get "Show post" do
      tags "Posts"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "200", "post found" do
        let(:user) { create(:user) }
        let(:post_record) { create(:post, user: user) }
        let(:id) { post_record.id }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: user.id)}" }

        schema BaseResponseSchema.call(data_schema: PostSchema)

        run_test!
      end

      response "404", "post not found" do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: user.id)}" }
        let(:id) { 999999 }

        run_test!
      end
    end

    # 3. Удаление поста
    delete "Delete post" do
      tags "Posts"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "200", "post deleted" do
        let(:user) { create(:user) }
        let(:post_record) { create(:post, user: user) }
        let(:id) { post_record.id }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: user.id)}" }

        run_test!
      end

      response "403", "not your post" do
        let(:user) { create(:user) }
        let(:other_user) { create(:user) }
        let(:post_record) { create(:post, user: other_user) }
        let(:id) { post_record.id }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: user.id)}" }

        run_test!
      end
    end
  end

  # 4. Лайк поста
  path "/api/v1/posts/{id}/like" do
    parameter name: :id, in: :path, type: :integer, required: true

    post "Like post" do
      tags "Posts"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "201", "post liked" do
        let(:user) { create(:user) }
        let(:post_record) { create(:post) }
        let(:id) { post_record.id }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: user.id)}" }

        run_test!
      end
    end

    # 5. Удаление лайка
    delete "Unlike post" do
      tags "Posts"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "200", "post unliked" do
        let(:user) { create(:user) }
        let(:post_record) { create(:post) }
        let!(:like) { create(:like, user: user, post: post_record) }
        let(:id) { post_record.id }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: user.id)}" }

        run_test!
      end
    end
  end

  # 6. Репорт (жалоба) на пост
  path "/api/v1/posts/{id}/report" do
    parameter name: :id, in: :path, type: :string, required: true

    post "Report a post" do
      tags "Posts"
      consumes "application/json"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: :report,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    report: {
                      type: :object,
                      properties: {
                        reason: { type: :string, example: "Spam" },
                        category: { type: :string, enum: ["spam", "abuse", "other"] }
                      },
                      required: ["reason"]
                    }
                  }
                }

      response "201", "report created" do
        let(:user) { create(:user) }
        let(:post_record) { create(:post) }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: user.id)}" }
        let(:id) { post_record.id }
        let(:report) { { report: { reason: "Spam", category: "spam" } } }

        run_test!
      end

      response "422", "already reported" do
        let(:user) { create(:user) }
        let(:post_record) { create(:post) }
        let(:Authorization) { "Bearer #{Jwt::Encoder.call(user_id: user.id)}" }
        let(:id) { post_record.id }
        let(:report) { { report: { reason: "Spam" } } }

        before { create(:report, user: user, reportable: post_record) }

        run_test!
      end
    end
  end
end