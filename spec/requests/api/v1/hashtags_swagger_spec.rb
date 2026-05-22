require "swagger_helper"

RSpec.describe "Hashtags API", type: :request, swagger_doc: "v1/swagger.yaml" do
  path "/api/v1/hashtags/{id}/posts" do
    get "Get posts by hashtag" do
      tags "Hashtags"

      produces "application/json"

      parameter name: :id,
                in: :path,
                type: :string,
                description: "Hashtag name"

      response "200", "posts found" do
        let(:user) do
          User.create!(
            email: "john@example.com",
            username: "john",
            password: "password"
          )
        end

        let!(:post) do
          Post.create!(
            user: user,
            body: "Hello #ruby"
          )
        end

        let(:id) { "ruby" }

        before do
          ParsePostContentJob.perform_now(post.id)
        end

        run_test!
      end
    end
  end
end
