require "swagger_helper"

RSpec.describe "Posts API", type: :request do
  path "/api/v1/posts" do
    get "List posts" do
      tags "Posts"

      produces "application/json"

      security [ bearerAuth: [] ]

      response "200", "posts list" do
        schema BaseResponseSchema.call(
            data_schema: {
            type: :array,
            items: PostSchema
            },
            meta_schema: PaginationMetaSchema
        )

        let(:user) { create(:user) }

        let(:Authorization) do
          "Bearer #{Jwt::Encoder.call(user_id: user.id)}"
        end

        example "application/json", :success_response, {
          data: [
            {
              id: 1,
              body: "Hello world",
              created_at: "2026-05-29T10:00:00Z",
              likes_count: 5,
              comments_count: 2,
              hashtags: ["ruby", "rails"],
              author: {
                id: 1,
                username: "john_doe"
              }
            }
          ],
          meta: {
            current_page: 1,
            next_page: nil,
            prev_page: nil,
            total_pages: 1,
            total_count: 1
          },
          errors: []
        }

        run_test!
      end
    end
  end
end