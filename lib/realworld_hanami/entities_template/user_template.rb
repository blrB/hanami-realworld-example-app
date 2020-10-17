class UserTemplate < Hanami::Entity

  def self.user(user, token = nil)
    {
      user: user.as_json(email: true, token: token)
    }.to_json
  end

  def self.profile(user, current_user = nil)
    {
      profile: user.as_json(current_user: current_user)
    }.to_json
  end

end
