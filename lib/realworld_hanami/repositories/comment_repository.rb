class CommentRepository < Hanami::Repository
  associations do
    belongs_to :user, as: :author
    # belongs_to :article
  end

  def find_with_author(id)
    aggregate(:author).where(id: id).map_to(Comment).one
  end

  def find_all_with_author(article_id)
    aggregate(:author).where(article_id: article_id).map_to(Comment).to_a
  end

end
