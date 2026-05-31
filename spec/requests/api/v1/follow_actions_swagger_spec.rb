require "swagger_helper"

RSpec.describe "Follow Actions API", type: :request do
  path "/api/v1/users/{id}/follow/accept" do
    patch "Accept follow request" do
      tags "Follow Requests"

      produces "application/json"

      security [ bearerAuth: [] ]

      parameter name: :id,
                in: :path,
                schema: { type: :integer }

      response "200", "request accepted" do
        run_test!
      end
    end
  end

  path "/api/v1/users/{id}/follow/reject" do
    patch "Reject follow request" do
      tags "Follow Requests"

      produces "application/json"

      security [ bearerAuth: [] ]

      parameter name: :id,
                in: :path,
                schema: { type: :integer }

      response "200", "request rejected" do
        run_test!
      end
    end
  end
end

