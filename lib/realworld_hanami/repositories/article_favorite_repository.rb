class ArticleFavoriteRepository < Hanami::Repository
  associations do
    belongs_to :article
    belongs_to :user
  end

  def find_or_create(article_id:, favorit_id:)
    result = article_favorites.where(article_id: article_id, favorit_id: favorit_id).first
    result ? result : create(article_id: article_id, favorit_id: favorit_id)
  end

  def delete_by_ids(article_id:, favorit_id:)
    article_favorites.where(article_id: article_id, favorit_id: favorit_id).delete
  end

end
