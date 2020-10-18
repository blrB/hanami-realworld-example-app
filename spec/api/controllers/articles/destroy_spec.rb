RSpec.describe Api::Controllers::Articles::Destroy, type: :action do
  let(:action) { described_class.new }
  let(:params) { { slug: 'how-to-train-your-dragon' } }
  let(:article_repository) { ArticleRepository.new }
  let(:user_repository) { UserRepository.new }
  let(:tag_repository) { TagRepository.new }
  let(:user) { user_repository.create(FactoryBot.attributes_for(:user)) }
  let(:user2) { user_repository.create(FactoryBot.attributes_for(:user2)) }
  let(:article) { article_repository.create_with_tags(FactoryBot.attributes_for(:article).merge(author_id: user.id)) }
  let(:article2) { article_repository.create_with_tags(FactoryBot.attributes_for(:article2).merge(author_id: user2.id)) }

  describe "destroy article" do

    before do
      tag_repository.clear
      user_repository.clear
      article_repository.clear

      user
      article
      article2
    end

    it 'is need authentication' do
      response = action.call(params)
      expect(response[0]).to eq 401
    end

    it 'is successful' do
      expect(article_repository.articles.count).to eq 2
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200
      expect(article_repository.articles.count).to eq 1
    end

    it 'is can\'t delete other authors articles' do
      response = action.call(params.merge('slug' => 'how-to-train-your-dragon-2', 'HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 403
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Only author can delete article'] })
    end

    it 'is article not exist' do
      response = action.call(params.merge('slug' => 'not_exist_slug', 'HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 404
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Article not exist'] })
    end

  end
end
