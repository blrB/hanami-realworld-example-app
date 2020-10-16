class TagTemplate < Hanami::Entity

  def self.list(tags)
    {
      tags: tags
    }.to_json
  end

end
