class CommentTemplate < Hanami::Entity

  def self.comment(comment)
    {
      comment: comment,
    }.to_json
  end

  def self.list(comments)
    {
      comments: comments
    }.to_json
  end

end
