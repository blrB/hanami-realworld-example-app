class TagRepository < Hanami::Repository
  # associations do
  #   has_many :articles, through: :article_tags
  # end

  def list
    tags.to_a
  end

  def find_or_create(name)
    result = tags.where(name: name).first
    result ? result : create(name: name)
  end

  def create_new_tags_for_article(tags: [], article: nil)
    article_tag_repository = ArticleTagRepository.new if article
    tags.map do |tag_name|
      tag = find_or_create(tag_name)
      article_tag_repository.create(article_id: article.id, tag_id: tag.id) if article
    end
  end

  # def find_with_articles(id)
  #   aggregate(:articles).where(id: id).map_to(Tag).one
  # end

end
