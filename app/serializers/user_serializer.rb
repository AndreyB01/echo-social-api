class UserSerializer
  def self.render(user)
    {
      id: user.id,
      email: user.email,
      username: user.username,
      display_name: user.display_name,
      bio: user.bio
    }
  end

  def self.render_collection(users)
    users.map { |user| render(user) }
  end
end