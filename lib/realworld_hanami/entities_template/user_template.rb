class UserTemplate < Hanami::Entity

  USER_PROPERTIES = [:email, :token, :username, :bio, :image]
  PROFILE_PROPERTIES = [:username, :bio, :image, :following]

  def self.user(user)
    {
      user: user.
        to_h.
        merge(token: JWTHelper.decode(user)).
        select {|k,_| USER_PROPERTIES.include?(k)}.
        sort_by { |k, _| USER_PROPERTIES.index(k) }.
        to_h
    }.to_json
  end

  def self.profile(user, following = false)
    {
      profile: user.
        to_h.
        merge(following: following).
        select {|k,_| PROFILE_PROPERTIES.include?(k)}.
        sort_by { |k, _| PROFILE_PROPERTIES.index(k) }.
        to_h
    }.to_json
  end

end
