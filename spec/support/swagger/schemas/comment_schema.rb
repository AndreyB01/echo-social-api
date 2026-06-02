# frozen_string_literal: true

CommentSchema = {
  type: :object,
  properties: {
    id: {
      type: :integer,
      example: 1
    },
    body: {
      type: :string,
      example: "Nice post!"
    },
    created_at: {
      type: :string,
      format: :"date-time"
    },
    author: {
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
      }
    }
  },
  required: %w[
    id
    body
    created_at
    author
  ]
}.freeze