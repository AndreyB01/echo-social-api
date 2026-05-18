require "rails_helper"

RSpec.describe Notification, type: :model do
  subject(:notification) { create(:notification) }

  describe "associations" do
    it { should belong_to(:user) }

    it do
      should belong_to(:actor)
        .class_name("User")
    end

    it { should belong_to(:notifiable) }
  end

  describe "validations" do
    it do
      should validate_presence_of(:notification_type)
    end
  end

  describe "scopes" do
    let!(:read_notification) do
      create(
        :notification,
        read_at: Time.current
      )
    end

    let!(:unread_notification) do
      create(
        :notification,
        read_at: nil
      )
    end

    it "returns unread notifications" do
      expect(Notification.unread)
        .to include(unread_notification)

      expect(Notification.unread)
        .not_to include(read_notification)
    end
  end
end