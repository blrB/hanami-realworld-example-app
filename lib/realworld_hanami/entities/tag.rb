class Tag < Hanami::Entity

  def as_json(options={})
    name
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end
