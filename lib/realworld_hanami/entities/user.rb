class User < Hanami::Entity

  def as_json(options={})
    result = {}
    result.merge!(email: email) if options[:email]
    result.merge!(token: options[:token]) if options[:token]
    result.merge!(username: username, bio: bio, image: image)
    result.merge!(following: ActiveRelationshipRepository.new.user_is_following?(follower_id: options[:current_user].id, followed_id: id)) if options[:current_user]
    result
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end
