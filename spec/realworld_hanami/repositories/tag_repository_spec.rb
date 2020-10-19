RSpec.describe TagRepository, type: :repository do
  let(:repository) { described_class.new }
  let(:tag) { repository.create(FactoryBot.attributes_for(:tag)) }
  let(:tag2) { repository.create(FactoryBot.attributes_for(:tag2)) }

  describe "tag repository works" do

    before do
      repository.clear
      tag
      tag2
    end

    it "retrieves list appropriate record" do
      result = repository.list
      expect(result).to be_an_instance_of(Array)
      expect(repository.list).to include(tag, tag2)
    end

    it "changed after add in list" do
      new_tag = repository.create(name: 'new_tag')

      result = repository.list
      expect(result).to be_an_instance_of(Array)
      expect(repository.list).to include(tag, tag2, new_tag)
    end

    it "find_or_create with old tag" do
      old_tag = repository.find_or_create(tag.name)
      expect(old_tag.name).to eq tag.name
      expect(repository.tags.count).to eq 2
    end

    it "find_or_create create new" do
      new_tag = repository.find_or_create('new_tag')
      expect(new_tag.name).to eq 'new_tag'
      expect(repository.tags.count).to eq 3
      expect(repository.list).to include(new_tag)
    end

    it "create new tags for article when" do
      article_tag_repository = ArticleTagRepository.new
      article_tag_repository.clear
      user_repository = UserRepository.new
      user_repository.clear
      user = user_repository.create(FactoryBot.attributes_for(:user))
      article_repository = ArticleRepository.new
      article_repository.clear
      article = article_repository.create(FactoryBot.attributes_for(:article).merge(author_id: user.id))

      tags = repository.create_new_tags_for_article(tags: [tag.name, 'new_tag'], article: article)
      expect(repository.tags.count).to eq 3
      article_tags = article_tag_repository.article_tags.to_a
      expect(article_tags.size).to eq 2
      expect(tags.first.id).to eq article_tags.first.tag_id
      expect(tags.last.id).to eq article_tags.last.tag_id
    end

  end
end
