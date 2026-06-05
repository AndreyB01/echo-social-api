require "swagger_helper"

RSpec.describe "Admin API", type: :request do
  path "/api/v1/admin/reports" do
    get "List reports" do
      tags "Admin"
      produces "application/json"
      security [ bearerAuth: [] ]
      description "Admin only. Returns all reports."

      response "200", "reports list" do
        let(:admin) { create(:user, admin: true) }
        let(:Authorization) { "Bearer #{auth_token_for(admin)}" }

        run_test!
      end

      response "403", "forbidden" do
        let(:user) { create(:user, admin: false) }
        let(:Authorization) { "Bearer #{auth_token_for(user)}" }

        run_test!
      end
    end
  end

  path "/api/v1/admin/posts/{id}/hide" do
    parameter name: :id, in: :path, type: :integer, required: true

    patch "Hide post" do
      tags "Admin"
      produces "application/json"
      security [ bearerAuth: [] ]
      description "Admin only. Sets hidden_at on post."

      response "200", "post hidden" do
        let(:admin) { create(:user, admin: true) }
        let(:post) { create(:post) }
        let(:Authorization) { "Bearer #{auth_token_for(admin)}" }
        let(:id) { post.id }

        run_test!
      end

      response "403", "forbidden" do
        let(:user) { create(:user, admin: false) }
        let(:post) { create(:post) }
        let(:Authorization) { "Bearer #{auth_token_for(user)}" }
        let(:id) { post.id }

        run_test!
      end
    end
  end

  path "/api/v1/admin/users/{id}/ban" do
    parameter name: :id, in: :path, type: :integer, required: true

    patch "Ban user" do
      tags "Admin"
      produces "application/json"
      security [ bearerAuth: [] ]
      description "Admin only. Sets banned_at on user."

      response "200", "user banned" do
        let(:admin) { create(:user, admin: true) }
        let(:target_user) { create(:user) }
        let(:Authorization) { "Bearer #{auth_token_for(admin)}" }
        let(:id) { target_user.id }

        run_test!
      end

      response "403", "forbidden" do
        let(:user) { create(:user, admin: false) }
        let(:target_user) { create(:user) }
        let(:Authorization) { "Bearer #{auth_token_for(user)}" }
        let(:id) { target_user.id }

        run_test!
      end
    end
  end
end

