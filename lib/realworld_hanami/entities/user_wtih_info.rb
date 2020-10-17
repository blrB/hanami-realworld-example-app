class UserWithInfo < Hanami::Entity

  def as_json(options={})
    {
      username: username,
      bio: bio,
      image: image,
      following: following
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end
