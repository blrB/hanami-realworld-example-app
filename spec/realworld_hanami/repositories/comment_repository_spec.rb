RSpec.describe CommentRepository, type: :repository do
  let(:repository) { described_class.new }
  let(:params) { Hash[] }
  let(:article_repository) { ArticleRepository.new }
  let(:user_repository) { UserRepository.new }
  let(:active_relationship_repository) { ActiveRelationshipRepository.new }
  let(:tag_repository) { TagRepository.new }
  let(:comment_repository) { CommentRepository.new }
  let(:user) { user_repository.create(FactoryBot.attributes_for(:user)) }
  let(:user2) { user_repository.create(FactoryBot.attributes_for(:user2)) }
  let(:article) { article_repository.create_with_tags(FactoryBot.attributes_for(:article).merge(author_id: user.id)) }
  let(:article2) { article_repository.create_with_tags(FactoryBot.attributes_for(:article2).merge(author_id: user2.id)) }
  let(:comment) { comment_repository.create(FactoryBot.attributes_for(:comment).merge(article_id: article.id, author_id: user.id)) }
  let(:comment2) { comment_repository.create(FactoryBot.attributes_for(:comment2).merge(article_id: article.id, author_id: user2.id)) }
  let(:comment3) { comment_repository.create(FactoryBot.attributes_for(:comment3).merge(article_id: article2.id, author_id: user.id)) }

  before do
    tag_repository.clear
    user_repository.clear
    article_repository.clear
    comment_repository.clear
    active_relationship_repository.clear

    user
    user2
    article
    article2
    comment
    comment2
    comment3
  end

  describe "comment repository works" do

    it 'find by id and article id appropriate record' do
      comment_from_repository = repository.find_by_id_and_article_id(id: comment.id, article_id: article.id)
      expect(comment_from_repository).to eq comment
    end

    it 'find by id and article id appropriate record when comment and article not connect' do
      comment_from_repository = repository.find_by_id_and_article_id(id: comment.id, article_id: article2.id)
      expect(comment_from_repository).to be_nil
    end

    it 'find by author info by id when no following' do
      comments = repository.find_with_author_info(id: comment.id, current_user_id: user2.id)
      expect(comments.size).to eq 1

      comment_from_repository = comments.first
      expect(comment_from_repository.to_h).to include(id: comment.id)
      expect(comment_from_repository.to_h).to include(:body, :created_at, :updated_at, :author)

      author = comment_from_repository.author
      expect(author.to_h).to include(username: user.username, following: false)
      expect(author.to_h).to include(:bio, :image)
    end

    it 'find by author info by id when following' do
      active_relationship_repository.find_or_create(follower_id: user2.id, followed_id: user.id)

      comments = repository.find_with_author_info(id: comment.id, current_user_id: user2.id)
      expect(comments.size).to eq 1

      comment_from_repository = comments.first
      author = comment_from_repository.author
      expect(author.to_h).to include(username: user.username, following: true)
    end

    it 'find by author info by article_id' do
      comments = repository.find_with_author_info(article_id: article.id, current_user_id: user2.id)
      expect(comments.size).to eq 2

      comment_from_repository = comments.first
      expect(comment_from_repository.to_h).to include(id: comment.id)
      comment_from_repository = comments.last
      expect(comment_from_repository.to_h).to include(id: comment2.id)

      comments = repository.find_with_author_info(article_id: article2.id, current_user_id: user2.id)
      expect(comments.size).to eq 1

      comment_from_repository = comments.first
      expect(comment_from_repository.to_h).to include(id: comment3.id)
    end

  end
end