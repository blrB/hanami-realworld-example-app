RSpec.describe Api::Controllers::Articles::Feed, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[] }
  let(:article_repository) { ArticleRepository.new }
  let(:user_repository) { UserRepository.new }
  let(:tag_repository) { TagRepository.new }
  let(:user) { user_repository.create(FactoryBot.attributes_for(:user)) }
  let(:user2) { user_repository.create(FactoryBot.attributes_for(:user2)) }
  let(:article) { article_repository.create_with_tags(FactoryBot.attributes_for(:article).merge(author_id: user.id)) }
  let(:article2) { article_repository.create_with_tags(FactoryBot.attributes_for(:article2).merge(author_id: user2.id)) }
  let(:article3) { article_repository.create_with_tags(FactoryBot.attributes_for(:article3).merge(author_id: user.id)) }

  describe "get all feed" do

    before do
      tag_repository.clear
      user_repository.clear
      article_repository.clear

      user
      article
      article2
      article3
    end

    it 'is need authentication' do
      response = action.call(params)
      expect(response[0]).to eq 401
    end

    it 'is successful' do
      ActiveRelationshipRepository.new.find_or_create(follower_id: user2.id, followed_id: user.id)

      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user2)}"))
      expect(response[0]).to eq 200

      response_hash = JSON(response[2][0], symbolize_names: true)
      expect(response_hash[:articles]).to be_an_instance_of(Array)
      expect(response_hash[:articlesCount]).to eq 2

      article_from_response = response_hash[:articles].first
      expect(article_from_response).to include({ "slug": "how-to-train-your-dragon-3" })

      article_from_response = response_hash[:articles].last
      expect(article_from_response).to include({ "slug": "how-to-train-your-dragon" })
    end
  end
end
