# frozen_string_literal: true

PostSchema = {
  type: :object,
  properties: {
    id: {
      type: :integer,
      example: 1
    },
    body: {
      type: :string,
      example: "Hello world"
    },
    created_at: {
      type: :string,
      format: :"date-time"
    },
    likes_count: {
      type: :integer,
      example: 5
    },
    comments_count: {
      type: :integer,
      example: 2
    },
    hashtags: {
      type: :array,
      items: {
        type: :string
      },
      example: %w[ruby rails]
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
        }
      }
    }
  },
  required: %w[
    id
    body
    created_at
  ]
}.freeze