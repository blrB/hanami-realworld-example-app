class TagRepository < Hanami::Repository

  def list
    tags.to_a
  end

  def find_or_create(name)
    result = tags.where(name: name).first
    result ? result : create(name: name)
  end

  def create_new_tags_for_article(tags:, article:)
    article_tag_repository = ArticleTagRepository.new
    tags.map do |tag_name|
      tag = find_or_create(tag_name)
      article_tag_repository.create(article_id: article.id, tag_id: tag.id)
      tag
    end
  end

end
