# frozen_string_literal: true

NotificationSchema = {
  type: :object,
  properties: {
    id: {
      type: :integer,
      example: 1
    },
    type: {
      type: :string,
      example: "like"
    },
    read: {
      type: :boolean,
      example: false
    },
    created_at: {
      type: :string,
      format: :"date-time"
    },
    actor: {
      type: :object,
      properties: {
        id: {
          type: :integer,
          example: 2
        },
        username: {
          type: :string,
          example: "alice"
        }
      }
    }
  },
  required: %w[
    id
    type
    read
    created_at
  ]
}.freeze