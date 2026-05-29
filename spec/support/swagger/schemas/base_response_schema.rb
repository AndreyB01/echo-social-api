# frozen_string_literal: true

BaseResponseSchema = lambda do |data_schema:, meta_schema: nil|
  {
    type: :object,
    properties: {
      data: data_schema,
      meta: meta_schema || {
        type: :object,
        nullable: true
      },
      errors: {
        type: :array,
        items: {
          type: :string
        },
        example: []
      }
    },
    required: %w[data]
  }
end
