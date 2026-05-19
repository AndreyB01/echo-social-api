require "rails_helper"

RSpec.describe RealtimeEventSerializer do
  describe ".render" do
    let(:payload) do
      described_class.render(
        event: "notification.created",
        data: {
          id: 1
        }
      )
    end

    it "renders event name" do
      expect(payload[:event])
        .to eq("notification.created")
    end

    it "renders timestamp" do
      expect(payload[:timestamp])
        .not_to be_nil
    end

    it "renders data" do
      expect(payload[:data])
        .to eq(id: 1)
    end
  end
end