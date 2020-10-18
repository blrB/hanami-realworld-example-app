class CommentWithInfo < Hanami::Entity

  def as_json(options={})
    {
      id: id,
      createdAt: created_at.iso8601(3),
      updatedAt: updated_at.iso8601(3),
      body: body,
      author: author
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end
