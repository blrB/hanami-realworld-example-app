RSpec.describe ArticleFavoriteRepository, type: :repository do
  let(:repository) { described_class.new }
  let(:user_repository) { UserRepository.new }
  let(:article_repository) { ArticleRepository.new }
  let(:user) { user_repository.create(FactoryBot.attributes_for(:user)) }
  let(:article) { article_repository.create_with_tags(FactoryBot.attributes_for(:article).merge(author_id: user.id)) }

  before do
    repository.clear
    user_repository.clear
    article_repository.clear
    user
    article
  end

  describe "article favorite repository works" do

    it "can create favorite" do
      repository.find_or_create(article_id: article.id, favorit_id: user.id)

      repository.article_favorites.to_a
      expect(repository.article_favorites.count).to eq 1
    end

    it "can destroy favorite" do
      repository.find_or_create(article_id: article.id, favorit_id: user.id)
      repository.delete_by_ids(article_id: article.id, favorit_id: user.id)
      expect(repository.article_favorites.count).to eq 0
    end
  end
end
