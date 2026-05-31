require "swagger_helper"

RSpec.describe "Mutes API", type: :request do
  path "/api/v1/users/{id}/mute" do
    parameter name: :id, in: :path, type: :integer

    post "Mute user" do
      tags "Mutes"
      security [ bearerAuth: [] ]
      produces "application/json"

      response "201", "user muted" do
        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              muted: { type: :boolean },
              user_id: { type: :integer }
            }
          }
        )

        let(:id) { 1 }

        run_test!
      end
    end

    delete "Unmute user" do
      tags "Mutes"
      security [ bearerAuth: [] ]
      produces "application/json"

      response "200", "user unmuted" do
        schema BaseResponseSchema.call(
          data_schema: {
            type: :object,
            properties: {
              muted: { type: :boolean },
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

