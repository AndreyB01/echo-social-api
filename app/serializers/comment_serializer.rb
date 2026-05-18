class CommentSerializer
  def self.render(comment)
    {
      id: comment.id,
      body: comment.body,
      created_at: comment.created_at,

      author: UserSerializer.render(comment.user)
    }
  end

  def self.render_collection(comments)
    comments.map { |comment| render(comment) }
  end
end