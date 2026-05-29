# frozen_string_literal: true

ProfileSchema = {
  type: :object,
  properties: {
    id: {
      type: :integer,
      example: 1
    },
    email: {
      type: :string,
      example: "john@example.com"
    },
    username: {
      type: :string,
      example: "john_doe"
    },
    display_name: {
      type: :string,
      nullable: true,
      example: "John Doe"
    },
    bio: {
      type: :string,
      nullable: true,
      example: "Ruby developer"
    }
  },
  required: %w[
    id
    email
    username
  ]
}.freeze
