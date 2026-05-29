# frozen_string_literal: true

NotFoundErrorSchema = {
  type: :object,
  properties: {
    error: {
      type: :string,
      example: "Couldn't find Post"
    }
  },
  required: ["error"]
}.freeze
