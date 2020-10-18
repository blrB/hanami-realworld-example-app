RSpec.describe Api::Controllers::Articles::Index, type: :action do
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

  describe "get all articles" do

    before do
      tag_repository.clear
      user_repository.clear
      article_repository.clear

      user
      article
      article2
      article3
    end

    it 'is no need authentication' do
      response = action.call(params)
      expect(response[0]).to eq 200
    end

    it 'is successful' do
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200

      response_hash = JSON(response[2][0], symbolize_names: true)
      expect(response_hash[:articles]).to  be_an_instance_of(Array)
      expect(response_hash[:articlesCount]).to eq 3

      article_from_response = response_hash[:articles].last
      expect(article_from_response).to  be_an_instance_of(Hash)
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

    it 'is successful with param "tag"' do
      response = action.call(params.merge('tag' => 'dragons2', 'HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200

      response_hash = JSON(response[2][0], symbolize_names: true)
      expect(response_hash[:articlesCount]).to eq 1

      article_from_response = response_hash[:articles].first
      expect(article_from_response).to include({ "tagList": ["dragons2", "training2"] })
    end

    it 'is successful with param "author"' do
      response = action.call(params.merge('author' => user2.username, 'HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200

      response_hash = JSON(response[2][0], symbolize_names: true)
      expect(response_hash[:articlesCount]).to eq 1

      article_from_response = response_hash[:articles].first
      expect(article_from_response).to include({ "slug": "how-to-train-your-dragon-2" })
    end

    it 'is successful with param "favorited"' do
      ArticleFavoriteRepository.new.find_or_create(article_id: article.id, favorit_id: user2.id)
      ArticleFavoriteRepository.new.find_or_create(article_id: article3.id, favorit_id: user2.id)

      response = action.call(params.merge('favorited' => user2.username, 'HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200

      response_hash = JSON(response[2][0], symbolize_names: true)
      expect(response_hash[:articlesCount]).to eq 2

      article_from_response = response_hash[:articles].first
      expect(article_from_response).to include({ "slug": "how-to-train-your-dragon-3" })

      article_from_response = response_hash[:articles].last
      expect(article_from_response).to include({ "slug": "how-to-train-your-dragon" })
    end

    it 'is successful with param "limit"' do
      response = action.call(params.merge('limit' => 2, 'HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200

      response_hash = JSON(response[2][0], symbolize_names: true)
      expect(response_hash[:articlesCount]).to eq 2

      article_from_response = response_hash[:articles].last
      expect(article_from_response).to include({ "slug": "how-to-train-your-dragon-2" })
    end

    it 'is successful with param "offset"' do
      response = action.call(params.merge('offset' => 1, 'HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200

      response_hash = JSON(response[2][0], symbolize_names: true)
      expect(response_hash[:articlesCount]).to eq 2

      article_from_response = response_hash[:articles].first
      expect(article_from_response).to include({ "slug": "how-to-train-your-dragon-2" })
    end
  end
end
