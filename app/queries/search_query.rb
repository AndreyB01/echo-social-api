class SearchQuery
LIMIT = 10

def initialize(query:)
@query = query.to_s.downcase.strip
end

def call
{
users: search_users,
hashtags: search_hashtags,
posts: search_posts
}
end

private

attr_reader :query

def search_users
User
.where("LOWER(username) LIKE :q OR LOWER(display_name) LIKE :q", q: "%#{query}%")
.limit(LIMIT)
end

def search_hashtags
Hashtag
.where("LOWER(name) LIKE ?", "%#{query}%")
.limit(LIMIT)
end

def search_posts
Post
.includes(:user)
.where("LOWER(body) LIKE ?", "%#{query}%")
.order(created_at: :desc)
.limit(LIMIT)
end
end
