class UserRepository < Hanami::Repository

  def find_by_email(email)
    users.where(email: email).first
  end

  def find_by_username(username)
    users.where(username: username).first
  end

  def following(user)
    users.select(:id, :email, :username, :bio, :image).join(:active_relationships, followed_id: :id).where(follower_id: user.id).to_a
  end

end
