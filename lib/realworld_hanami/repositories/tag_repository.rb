class TagRepository < Hanami::Repository
  # associations do
  #   has_many :articles, through: :article_tags
  # end

  def list
    tags.to_a
  end

  # def find_with_articles(id)
  #   aggregate(:articles).where(id: id).map_to(Tag).one
  # end

end
