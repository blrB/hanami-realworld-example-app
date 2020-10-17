class ArticleTemplate < Hanami::Entity

  def self.article(article)
    {
      article: article,
    }.to_json
  end

  def self.list(articles)
    {
      articles: articles,
      articlesCount: articles.size
    }.to_json
  end

end
