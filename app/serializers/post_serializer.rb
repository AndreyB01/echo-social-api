class PostSerializer
  def self.render(post)
    {
      id: post.id,
      body: post.body,
      created_at: post.created_at,

      likes_count: post.likes.size,
      comments_count: post.comments.size,

      hashtags: post.respond_to?(:hashtags) ? post.hashtags.map(&:name) : [],

      author: {
        id: post.user.id,
        username: post.user.username,
        display_name: post.user.display_name
      }
    }
  end

  def self.render_collection(posts)
    posts.map { |post| render(post) }
  end
end