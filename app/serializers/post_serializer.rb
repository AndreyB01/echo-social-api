class PostSerializer
  include Rails.application.routes.url_helpers

  def self.render(post)
    new.render(post)
  end

  def self.render_collection(posts)
    posts.map { |post| new.render(post) }
  end

  def render(post)
    {
      id: post.id,
      body: post.body,
      created_at: post.created_at,

      likes_count: post.likes_count,
      comments_count: post.comments_count,

      hashtags: post.hashtags.map(&:name),

      images: image_urls(post),

      author: UserSerializer.render(post.user)
    }
  end

  private

  def image_urls(post)
    post.images.map do |image|
      rails_representation_url(
        image.variant(resize_to_limit: [1200, 1200]),
        only_path: false
      )
    end
  end
end