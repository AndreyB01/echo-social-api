require "swagger_helper"

RSpec.describe "Blocks API", type: :request do
  path "/api/v1/users/{id}/block" do
    parameter name: :id, in: :path, type: :integer

    post "Block user" do
      tags "Blocks"
      security [ bearerAuth: [] ]
      produces "application/json"

      response "201", "user blocked" do
        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              blocked: { type: :boolean },
              user_id: { type: :integer }
            }
          }
        )

        let(:id) { 1 }

        run_test!
      end
    end

    delete "Unblock user" do
      tags "Blocks"
      security [ bearerAuth: [] ]
      produces "application/json"

      response "200", "user unblocked" do
        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              blocked: { type: :boolean },
              user_id: { type: :integer }
            }
          }
        )

        let(:id) { 1 }

        run_test!
      end
    end
  end
end

