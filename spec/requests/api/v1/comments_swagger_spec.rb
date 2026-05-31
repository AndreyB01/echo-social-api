require "swagger_helper"

RSpec.describe "Comments API", type: :request do
path "/api/v1/posts/{post_id}/comments" do
parameter name: :post_id,
in: :path,
type: :integer,
required: true


get "List comments" do
  tags "Comments"

  produces "application/json"

  response "200", "comments list" do
    schema BaseResponseSchema.call(
      data_schema: {
        type: :array,
        items: CommentSchema
      },
      meta_schema: PaginationMetaSchema
    )

    example "application/json", :success_response, {
      data: [
        {
          id: 1,
          body: "Nice post!",
          created_at: "2026-05-29T10:00:00Z",
          author: {
            id: 1,
            username: "john_doe",
            display_name: "John Doe",
            avatar_url: nil
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

post "Create comment" do
  tags "Comments"

  consumes "application/json"
  produces "application/json"

  security [ bearerAuth: [] ]

  parameter name: :comment,
            in: :body,
            schema: {
              type: :object,
              properties: {
                comment: {
                  type: :object,
                  properties: {
                    body: {
                      type: :string,
                      example: "Nice post!"
                    }
                  },
                  required: ["body"]
                }
              }
            }

  response "201", "comment created" do
    schema BaseResponseSchema.call(
      data_schema: CommentSchema
    )

    run_test!
  end
end


end

path "/api/v1/posts/{post_id}/comments/{id}" do
parameter name: :post_id,
in: :path,
type: :integer,
required: true


parameter name: :id,
          in: :path,
          type: :integer,
          required: true

delete "Delete comment" do
  tags "Comments"

  produces "application/json"

  security [ bearerAuth: [] ]

  response "200", "comment deleted" do
    schema(
      type: :object,
      properties: {
        success: {
          type: :boolean,
          example: true
        }
      }
    )

    run_test!
  end
end


end
end
