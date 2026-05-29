# frozen_string_literal: true

UserSchema = {
  type: :object,
  properties: {
    id: {
      type: :integer,
      example: 1
    },
    username: {
      type: :string,
      example: "john_doe"
    },
    email: {
      type: :string,
      example: "john@example.com"
    },
    created_at: {
      type: :string,
      format: :"date-time"
    }
  },
  required: %w[id username email]
}.freeze