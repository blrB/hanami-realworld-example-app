RSpec.describe Api::Controllers::Articles::Show, type: :action do
  let(:action) { described_class.new }
  let(:params) { { slug: 'how-to-train-your-dragon' } }
  let(:article_repository) { ArticleRepository.new }
  let(:user_repository) { UserRepository.new }
  let(:tag_repository) { TagRepository.new }
  let(:user) { user_repository.create(FactoryBot.attributes_for(:user)) }
  let(:article) { article_repository.create_with_tags(FactoryBot.attributes_for(:article).merge(author_id: user.id)) }

  describe "show article" do

    before do
      tag_repository.clear
      user_repository.clear
      article_repository.clear

      user
      article
    end

    it 'is not need authentication' do
      response = action.call(params)
      expect(response[0]).to eq 200
    end

    it 'is successful' do
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200

      response_hash = JSON(response[2][0], symbolize_names: true)
      expect(response_hash[:article]).to  be_an_instance_of(Hash)

      article_from_response = response_hash[:article]
      expect(article_from_response).to include({
        "slug": "how-to-train-your-dragon",
        "title": "How to train your dragon",
        "description": "Ever wonder how?",
        "body": "It takes a Jacobian",
        "tagList": ["dragons", "training"],
        "favorited": false,
        "favoritesCount": 0,
      })
      expect(article_from_response[:author]).to include({
        "username": "Jacob",
        "following": false,
        "bio": nil,
        "image": nil
      })
      expect(article_from_response[:createdAt]).to match(/^\d{4,}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d:[0-5]\d.\d+(?:[+-][0-2]\d:[0-5]\d|Z)$/)
      expect(article_from_response[:updatedAt]).to match(/^\d{4,}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d:[0-5]\d.\d+(?:[+-][0-2]\d:[0-5]\d|Z)$/)
    end

    it 'is article not exist' do
      response = action.call(params.merge('slug' => 'not_exist_slug', 'HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 404
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Article not exist'] })
    end

  end
end