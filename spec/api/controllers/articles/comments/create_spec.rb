RSpec.describe Api::Controllers::Articles::Comments::Create, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[] }
  let(:article_repository) { ArticleRepository.new }
  let(:user_repository) { UserRepository.new }
  let(:tag_repository) { TagRepository.new }
  let(:comment_repository) { CommentRepository.new }
  let(:user) { user_repository.create(FactoryBot.attributes_for(:user)) }
  let(:article) { article_repository.create_with_tags(FactoryBot.attributes_for(:article).merge(author_id: user.id)) }

  before do
    tag_repository.clear
    user_repository.clear
    article_repository.clear
    comment_repository.clear

    user
    article
  end

  describe "create comment" do

    it 'is need authentication' do
      response = action.call(params)
      expect(response[0]).to eq 401
    end

    it 'is successful' do
      expect(comment_repository.comments.count).to eq 0
      params = JSON('
        {
          "comment": {
            "body": "His name was my name too."
          }
        }
      ')
      response = action.call(params.merge('slug' => 'how-to-train-your-dragon', 'HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200
      response_hash = JSON(response[2][0], symbolize_names: true)
      expect(response_hash[:comment]).to  be_an_instance_of(Hash)

      expect(response_hash[:comment]).to include({"body": "His name was my name too."})
      expect(response_hash[:comment][:author][:username]).to eq user.username
      expect(comment_repository.comments.count).to eq 1
    end

    it 'is params not valide' do
      params = JSON('
        {
          "comment": {
            "text": "His name was my name too."
          }
        }
      ')
      response = action.call(params.merge('slug' => 'how-to-train-your-dragon', 'HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 422
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Params not valide'] })
    end

    it 'is article not exist' do
      params = JSON('
        {
          "comment": {
            "body": "His name was my name too."
          }
        }
      ')
      response = action.call(params.merge('slug' => 'not_exist_slug', 'HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 404
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Article not exist'] })
    end
    
  end
end