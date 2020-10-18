RSpec.describe Api::Controllers::Articles::Favorites::Create, type: :action do
  let(:action) { described_class.new }
  let(:params) { { slug: 'how-to-train-your-dragon' } }
  let(:article_repository) { ArticleRepository.new }
  let(:user_repository) { UserRepository.new }
  let(:tag_repository) { TagRepository.new }
  let(:article_favorite_repository) { ArticleFavoriteRepository.new }
  let(:user) { user_repository.create(FactoryBot.attributes_for(:user)) }
  let(:article) { article_repository.create_with_tags(FactoryBot.attributes_for(:article).merge(author_id: user.id)) }

  before do
    tag_repository.clear
    user_repository.clear
    article_repository.clear
    article_favorite_repository.clear

    user
    article
  end

  describe "create favorite" do

    it 'is need authentication' do
      response = action.call(params)
      expect(response[0]).to eq 401
    end

    it 'is successful' do
      expect(article_favorite_repository.article_favorites.count).to eq 0

      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200
      response_hash = JSON(response[2][0], symbolize_names: true)
      expect(response_hash[:article]).to  be_an_instance_of(Hash)

      article_from_response = response_hash[:article]
      expect(article_from_response).to include({
        "slug": "how-to-train-your-dragon",
        "favorited": true,
        "favoritesCount": 1
      })
      expect(article_favorite_repository.article_favorites.count).to eq 1
    end

    it 'is article not exist' do
      response = action.call(params.merge('slug' => 'not_exist_slug', 'HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 404
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Article not exist'] })
    end

  end
end
