RSpec.describe ActiveRelationshipRepository, type: :repository do
  let(:repository) { described_class.new }
  let(:user_repository) { UserRepository.new }
  let(:user) { user_repository.create(FactoryBot.attributes_for(:user)) }
  let(:user2) { user_repository.create(FactoryBot.attributes_for(:user2)) }


  before do
    repository.clear
    user_repository.clear
    user
    user2
  end

  describe "active relationship repository works" do

    it "can check" do
      expect(repository.user_is_following?(follower_id: user.id, followed_id: user2.id)).to eq false
    end

    it "can follow" do
      repository.find_or_create(follower_id: user.id, followed_id: user2.id)
      expect(repository.user_is_following?(follower_id: user.id, followed_id: user2.id)).to eq true
    end

    it "can unfollow" do
      repository.find_or_create(follower_id: user.id, followed_id: user2.id)
      repository.delete_by_ids(follower_id: user.id, followed_id: user2.id)
      expect(repository.user_is_following?(follower_id: user.id, followed_id: user2.id)).to eq false
    end
  end
end
