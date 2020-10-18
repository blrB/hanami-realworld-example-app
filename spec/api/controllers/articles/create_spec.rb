RSpec.describe Api::Controllers::Articles::Create, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[] }
  let(:article_repository) { ArticleRepository.new }
  let(:user_repository) { UserRepository.new }
  let(:tag_repository) { TagRepository.new }
  let(:user) { user_repository.create(FactoryBot.attributes_for(:user)) }

  before do
    tag_repository.clear
    user_repository.clear
    article_repository.clear

    user
  end

  describe "create article" do

    it 'is need authentication' do
      response = action.call(params)
      expect(response[0]).to eq 401
    end

    it 'is successful' do
      expect(article_repository.articles.count).to eq 0
      params = JSON('
        {
          "article": {
            "title": "How to train your dragon",
            "description": "Ever wonder how?",
            "body": "It takes a Jacobian",
            "tagList": ["dragons", "training"]
          }
        }
      ')
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 201
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
      expect(article_repository.articles.count).to eq 1
    end

    it 'is can\'t create two articles with same title(slug)' do
      params = JSON('
        {
          "article": {
            "title": "How to train your dragon",
            "description": "Ever wonder how?",
            "body": "It takes a Jacobian",
            "tagList": ["dragons2", "training2"]
          }
        }
      ')
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 201
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 422
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Article with this title already exist'] })
    end

    it 'is params not valide' do
      params = JSON('
        {
          "article": {
            "title": "How to train your dragon"
          }
        }
      ')
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 422
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Params not valide'] })
    end

  end
end