class UserTemplate < Hanami::Entity

  def self.user(user, token = nil)
    {
      user: user.as_json(email: true, token: token)
    }.to_json
  end

  def self.profile(user, following = nil)
    {
      profile: user.as_json(following: following)
    }.to_json
  end

end
