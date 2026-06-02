# frozen_string_literal: true

FollowRequestSchema = {
  type: :object,
  properties: {
    id: {
      type: :integer,
      example: 1
    },
    follower: {
      type: :object,
      properties: {
        id: {
          type: :integer,
          example: 2
        },
        username: {
          type: :string,
          example: "john_doe"
        },
        display_name: {
          type: :string,
          example: "John Doe"
        }
      }
    }
  },
  required: %w[
    id
    follower
  ]
}.freeze

