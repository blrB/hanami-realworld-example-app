class Article < Hanami::Entity

  def self.title_to_slug(title)
    title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def as_json(options={})
    {
      slug: slug,
      title: title,
      description: description,
      body: body,
      tagList: tags,
      createdAt: created_at.iso8601,
      updatedAt: updated_at.iso8601,
      favorited: favorited,
      favoritesCount: favorites&.size,
      author: author
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end