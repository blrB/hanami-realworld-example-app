RSpec.describe UserRepository, type: :repository do
  let(:repository) { described_class.new }
  let(:user) { repository.create(FactoryBot.attributes_for(:user)) }
  let(:user2) { repository.create(FactoryBot.attributes_for(:user2)) }

  describe "user repository works" do

    before do
      repository.clear
      user
      user2
    end

    it "retrieves find_by_email appropriate record" do
      expect(repository.find_by_email("jake@jake.jake")).to eq(user)
    end

    it "retrieves find_by_email not found record" do
      expect(repository.find_by_email("wrong@example.com")).to be_nil
    end

    it "retrieves find_by_username appropriate record" do
      expect(repository.find_by_username("Jacob")).to eq(user)
    end

    it "retrieves find_by_username not found record" do
      expect(repository.find_by_username("not_jacob")).to be_nil
    end

    it "retrieves following appropriate record" do
      result = repository.following(user)
      expect(result).to be_an_instance_of(Array)
      expect(result.size).to eq 0
    end

    it "retrieves following appropriate record when following" do
      ActiveRelationshipRepository.new.create(follower_id: user.id, followed_id: user2.id)

      result = repository.following(user)
      expect(result).to be_an_instance_of(Array)
      expect(result.size).to eq 1
      expect(result.first).to include(id: user2.id, email: user2.email, username: user2.username)
    end
  end

end
