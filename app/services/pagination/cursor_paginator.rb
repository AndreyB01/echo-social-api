module Pagination
  class CursorPaginator
    DEFAULT_LIMIT = 20

    def initialize(scope, cursor: nil, limit: DEFAULT_LIMIT)
      @scope = scope
      @cursor = cursor
      @limit = normalize_limit(limit)
    end

    def call
      records = filtered_scope
        .limit(@limit + 1)

      has_next = records.size > @limit

      records = records.first(@limit)

      {
        records: records,
        meta: {
          next_cursor: next_cursor(records, has_next),
          limit: @limit,
          has_next: has_next
        }
      }
    end

    private

    attr_reader :scope, :cursor, :limit

    def filtered_scope
      scoped = scope.order(created_at: :desc)

      return scoped unless cursor.present?

      scoped.where("created_at < ?", decoded_cursor)
    end

    def next_cursor(records, has_next)
      return nil unless has_next
      return nil if records.empty?

      encode_cursor(records.last.created_at)
    end

    def encode_cursor(timestamp)
      Base64.urlsafe_encode64(timestamp.iso8601)
    end

    def decoded_cursor
      Time.iso8601(
        Base64.urlsafe_decode64(cursor)
      )
    rescue
      nil
    end

    def normalize_limit(limit)
      value = limit.to_i

      return DEFAULT_LIMIT if value <= 0

      [value, 100].min
    end
  end
end
