require 'rails_helper'

RSpec.describe "Notifications API", type: :request do
  let!(:user) { create(:user) }
  let!(:actor) { create(:user) }
  let!(:post) { create(:post, user: user) }

  let!(:like) do
    create(
      :like,
      user: actor,
      post: post
    )
  end

  let!(:notification) do
    create(
      :notification,
      user: user,
      actor: actor,
      notification_type: "like",
      notifiable: like
    )
  end

  let(:token) do
    Jwt::Encoder.call(user_id: user.id)
  end

  let(:headers) do
    {
      "Authorization" => "Bearer #{token}"
    }
  end

  describe "GET /api/v1/notifications" do
    before do
      get "/api/v1/notifications",
          headers: headers
    end

    it "returns notifications" do
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["data"].first)
        .to include(
          "id",
          "type",
          "read",
          "created_at",
          "actor"
        )
    end
  end

  describe "PATCH /api/v1/notifications/:id/read" do
    before do
      patch "/api/v1/notifications/#{notification.id}/read",
            headers: headers
    end

    it "marks notification as read" do
      expect(response).to have_http_status(:ok)

      notification.reload

      expect(notification.read_at).not_to be_nil
    end
  end

  describe "PATCH /api/v1/notifications/read_all" do
    let!(:second_notification) do
      create(
        :notification,
        user: user,
        actor: actor,
        notification_type: "follow",
        notifiable: actor
      )
    end

    before do
      patch "/api/v1/notifications/read_all",
            headers: headers
    end

    it "marks all notifications as read" do
      expect(response).to have_http_status(:ok)

      expect(
        user.notifications.where(read_at: nil).count
      ).to eq(0)
    end
  end

  describe "GET /api/v1/notifications/unread_count" do
    before do
      get "/api/v1/notifications/unread_count",
          headers: headers
    end

    it "returns unread notifications count" do
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["unread_count"]).to eq(1)
    end
  end
end