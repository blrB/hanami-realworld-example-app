RSpec.describe ActiveRelationshipRepository, type: :repository do
  let(:repository) { described_class.new }
  let(:user_repository) { UserRepository.new }

  describe "list of tags" do

    before do
      repository.clear
      user_repository.clear
      user
      user2
    end

    let(:user) do
      user_repository.create(
        email: "test@example.com",
        username: "username",
        password: PasswordHelper.create_password("password")
      )
    end

    let(:user2) do
      user_repository.create(
        email: "test2@example.com",
        username: "username2",
        password: PasswordHelper.create_password("password")
      )
    end

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
