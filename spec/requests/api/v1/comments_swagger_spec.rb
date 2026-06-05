require "swagger_helper"

RSpec.describe "Comments API", type: :request do
  path "/api/v1/posts/{post_id}/comments" do
    parameter name: :post_id, in: :path, type: :integer, required: true

    get "List comments" do
      tags "Comments"
      produces "application/json"

      response "200", "comments list" do
        let(:post_record) { create(:post) }
        let(:post_id) { post_record.id }

        schema BaseResponseSchema.call(
          data_schema: {
            type: :array,
            items: CommentSchema
          },
          meta_schema: PaginationMetaSchema
        )

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
                        body: { type: :string, example: "Nice post!" }
                      },
                      required: ["body"]
                    }
                  }
                }

      response "201", "comment created" do
        let(:user) { create(:user) }
        let(:post_record) { create(:post) }
        let(:Authorization) { "Bearer #{auth_token_for(user)}" }
        let(:post_id) { post_record.id }
        let(:comment) { { comment: { body: "Nice post!" } } }

        schema BaseResponseSchema.call(data_schema: CommentSchema)

        run_test!
      end
    end
  end

  path "/api/v1/posts/{post_id}/comments/{id}" do
    parameter name: :post_id, in: :path, type: :integer, required: true
    parameter name: :id, in: :path, type: :integer, required: true

    delete "Delete comment" do
      tags "Comments"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "200", "comment deleted" do
        let(:user) { create(:user) }
        let(:post_record) { create(:post) }
        let(:comment_record) { create(:comment, user: user, post: post_record) }
        let(:Authorization) { "Bearer #{auth_token_for(user)}" }
        let(:post_id) { post_record.id }
        let(:id) { comment_record.id }

        run_test!
      end

      response "403", "not authorized" do
        let(:user) { create(:user) }
        let(:other_user) { create(:user) }
        let(:post_record) { create(:post) }
        let(:comment_record) { create(:comment, user: other_user, post: post_record) }
        let(:Authorization) { "Bearer #{auth_token_for(user)}" }
        let(:post_id) { post_record.id }
        let(:id) { comment_record.id }

        run_test!
      end
    end
  end
end