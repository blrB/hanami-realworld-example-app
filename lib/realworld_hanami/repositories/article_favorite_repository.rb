class ArticleFavoriteRepository < Hanami::Repository
  associations do
    belongs_to :article
    belongs_to :user
  end
end
