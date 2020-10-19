RSpec.describe ArticleRepository, type: :repository do
  let(:article_repository) { described_class.new }
  let(:article_favorite_repository) { ArticleFavoriteRepository.new }
  let(:user_repository) { UserRepository.new }
  let(:tag_repository) { TagRepository.new }
  let(:user) { user_repository.create(FactoryBot.attributes_for(:user)) }
  let(:user2) { user_repository.create(FactoryBot.attributes_for(:user2)) }
  let(:article) { article_repository.create_with_tags(FactoryBot.attributes_for(:article).merge(author_id: user.id)) }
  let(:article2) { article_repository.create_with_tags(FactoryBot.attributes_for(:article2).merge(author_id: user2.id)) }
  let(:article3) { article_repository.create_with_tags(FactoryBot.attributes_for(:article3).merge(author_id: user.id)) }

  describe "active relationship repository works" do

    before do
      tag_repository.clear
      user_repository.clear
      article_repository.clear
      article_favorite_repository.clear

      user
      article
      article2
      article3
    end

    it "can check exist by slug" do
      expect(article_repository.exist_by_slug("how-to-train-your-dragon")).to eq true
      expect(article_repository.exist_by_slug("not-exist-slug")).to eq false
    end

    it "can check find by slug" do
      expect(article_repository.find_by_slug("how-to-train-your-dragon")).to eq article
      expect(article_repository.find_by_slug("how-to-train-your-dragon-2")).to eq article2
      expect(article_repository.find_by_slug("how-to-train-your-dragon-3")).to eq article3
      expect(article_repository.find_by_slug("not-exist-slug")).to be_nil
    end

    # by create_with_tags created current article, article2, article3
    it "can create with tags" do
      article_tag_repository = ArticleTagRepository.new
      article_tags_ids = article_tag_repository.article_tags.where(article_id: article2.id).to_a.map(&:tag_id)
      expect(article_tags_ids.size).to eq 2

      article_tags_name = tag_repository.tags.where(id: article_tags_ids).to_a.map(&:name)
      expect(article_tags_name).to include("dragons2", "training2")
    end

    it 'is successful find_all_with_tags_favorites_author_info without params' do
      results = article_repository.find_all_with_tags_favorites_author_info()
      expect(results).to  be_an_instance_of(Array)
      expect(results.size).to eq 3

      article_from_response = results.last
      expect(article_from_response.to_h).to include({
        "slug": "how-to-train-your-dragon",
        "title": "How to train your dragon",
        "description": "Ever wonder how?",
        "body": "It takes a Jacobian",
        "favorited": false,
        "favorites_count": 0,
      })
      expect(article_from_response.author.to_h).to include({
        "username": "Jacob",
        "following": false,
        "bio": nil,
        "image": nil
      })
      expect(article_from_response.tags.first.name).to eq "dragons"
      expect(article_from_response.tags.last.name).to eq "training"
      expect(article_from_response.to_h).to include(:created_at, :updated_at)
    end

    it 'is successful find_all_with_tags_favorites_author_info with param "tag"' do
      results = article_repository.find_all_with_tags_favorites_author_info(tag: 'dragons2')
      expect(results.size).to eq 1

      article_from_response = results.first
      expect(article_from_response.tags.map(&:name)).to include("dragons2", "training2")
    end

    it 'is successful find_all_with_tags_favorites_author_info with param "author"' do
      results = article_repository.find_all_with_tags_favorites_author_info(author: user2.username)
      expect(results.size).to eq 1

      article_from_response = results.first
      expect(article_from_response.to_h).to include(slug: "how-to-train-your-dragon-2")
    end

    it 'is successful find_all_with_tags_favorites_author_info with param "author_ids"' do
      results = article_repository.find_all_with_tags_favorites_author_info(author_ids: user2.id)
      expect(results.size).to eq 1

      article_from_response = results.first
      expect(article_from_response.to_h).to include(slug: "how-to-train-your-dragon-2")
    end

    it 'is successful find_all_with_tags_favorites_author_info with param "favorited"' do
      article_favorite_repository.find_or_create(article_id: article.id, favorit_id: user2.id)
      article_favorite_repository.find_or_create(article_id: article3.id, favorit_id: user2.id)

      results = article_repository.find_all_with_tags_favorites_author_info(favorited: user2.username)
      expect(results.size).to eq 2

      article_from_response = results.first
      expect(article_from_response.to_h).to include(slug: "how-to-train-your-dragon-3", favorited: false, favorites_count: 1)

      article_from_response = results.last
      expect(article_from_response.to_h).to include(slug: "how-to-train-your-dragon", favorited: false, favorites_count: 1)

    end

    it 'is successful find_all_with_tags_favorites_author_info with param "limit"' do
      results = article_repository.find_all_with_tags_favorites_author_info(limit: 2)
      expect(results.size).to eq 2

      article_from_response = results.last
      expect(article_from_response.to_h).to include(slug: "how-to-train-your-dragon-2")
    end

    it 'is successful find_all_with_tags_favorites_author_info with param "offset"' do
      results = article_repository.find_all_with_tags_favorites_author_info(offset: 1)
      expect(results.size).to eq 2

      article_from_response = results.first
      expect(article_from_response.to_h).to include(slug: "how-to-train-your-dragon-2")
    end

    it 'is successful find_all_with_tags_favorites_author_info with param "id"' do
      results = article_repository.find_all_with_tags_favorites_author_info(id: article2.id)
      expect(results.size).to eq 1

      article_from_response = results.first
      expect(article_from_response.to_h).to include(slug: "how-to-train-your-dragon-2")
    end

    it 'is successful find_all_with_tags_favorites_author_info with param "slug"' do
      results = article_repository.find_all_with_tags_favorites_author_info(slug: "how-to-train-your-dragon-2")
      expect(results.size).to eq 1

      article_from_response = results.first
      expect(article_from_response.to_h).to include(slug: "how-to-train-your-dragon-2")
    end

    it 'is successful find_all_with_tags_favorites_author_info with param "current_user_id"' do
      ActiveRelationshipRepository.new.find_or_create(follower_id: user.id, followed_id: user2.id)
      article_favorite_repository.find_or_create(article_id: article.id, favorit_id: user.id)
      article_favorite_repository.find_or_create(article_id: article.id, favorit_id: user2.id)
      article_favorite_repository.find_or_create(article_id: article3.id, favorit_id: user2.id)

      results = article_repository.find_all_with_tags_favorites_author_info(current_user_id: user.id)
      expect(results.size).to eq 3

      article_from_response = results.first
      expect(article_from_response.to_h).to include(slug: "how-to-train-your-dragon-3", favorited: false, favorites_count: 1)
      expect(article_from_response.author.to_h).to include(following: false)

      article_from_response = results[1]
      expect(article_from_response.to_h).to include(slug: "how-to-train-your-dragon-2", favorited: false, favorites_count: 0)
      expect(article_from_response.author.to_h).to include(following: true)

      article_from_response = results.last
      expect(article_from_response.to_h).to include(slug: "how-to-train-your-dragon", favorited: true, favorites_count: 2)
      expect(article_from_response.author.to_h).to include(following: false)
    end

  end
end
