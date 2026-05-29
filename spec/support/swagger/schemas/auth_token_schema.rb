# frozen_string_literal: true

AuthTokenSchema = {
  type: :object,
  properties: {
    access_token: {
      type: :string,
      example: "eyJhbGciOiJIUzI1NiJ9..."
    },
    refresh_token: {
      type: :string,
      example: "eyJhbGciOiJIUzI1NiJ9..."
    }
  },
  required: %w[
    access_token
    refresh_token
  ]
}.freeze
