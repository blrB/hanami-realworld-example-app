RSpec.describe Api::Controllers::Articles::Comments::Destroy, type: :action do
  let(:action) { described_class.new }
  let(:params) { { slug: 'how-to-train-your-dragon', id: comment.id } }
  let(:article_repository) { ArticleRepository.new }
  let(:user_repository) { UserRepository.new }
  let(:tag_repository) { TagRepository.new }
  let(:comment_repository) { CommentRepository.new }
  let(:user) { user_repository.create(FactoryBot.attributes_for(:user)) }
  let(:article) { article_repository.create_with_tags(FactoryBot.attributes_for(:article).merge(author_id: user.id)) }
  let(:comment) { comment_repository.create(FactoryBot.attributes_for(:comment).merge(article_id: article.id, author_id: user.id)) }

  before do
    tag_repository.clear
    user_repository.clear
    article_repository.clear
    comment_repository.clear

    user
    article
    comment
  end

  describe "destroy comment" do

    it 'is need authentication' do
      response = action.call(params)
      expect(response[0]).to eq 401
    end

    it 'is successful' do
      expect(comment_repository.comments.count).to eq 1
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200
      expect(comment_repository.comments.count).to eq 0
    end

    it 'is article not exist' do
      response = action.call(params.merge('slug' => 'not_exist_slug', 'HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 404
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Article not exist'] })
    end

  end
end