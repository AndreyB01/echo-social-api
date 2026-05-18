class UserSerializer
  def self.render(user)
    {
      id: user.id,
      username: user.username,
      display_name: user.display_name
    }
  end

  def self.render_collection(users)
    users.map { |user| render(user) }
  end
end