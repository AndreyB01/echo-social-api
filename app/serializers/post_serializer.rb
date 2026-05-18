class PostSerializer
  def self.render(post)
    {
      id: post.id,
      body: post.body,
      created_at: post.created_at,

      likes_count: post.likes_count,
      comments_count: post.comments_count,

      hashtags: post.hashtags.map(&:name),

      author: UserSerializer.render(post.user)
    }
  end

  def self.render_collection(posts)
    posts.map { |post| render(post) }
  end
end