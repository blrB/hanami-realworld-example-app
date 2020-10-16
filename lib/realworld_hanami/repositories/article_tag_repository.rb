class ArticleTagRepository < Hanami::Repository
  associations do
    belongs_to :article
    belongs_to :tag
  end
end
