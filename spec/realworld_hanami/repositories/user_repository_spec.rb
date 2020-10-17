RSpec.describe UserRepository, type: :repository do
  let(:repository) { described_class.new }

  describe "find user by email" do

    before do
      repository.clear
      user
    end

    let(:email) { "test@example.com" }
    let(:password) { "password" }
    let(:username) { "tester" }
    let(:user) do
      repository.create(
        email: email,
        username: username,
        password: PasswordHelper.create_password(password)
      )
    end

    describe "by existent email" do
      it "retrieves appropriate record" do
        expect(repository.find_by_email("test@example.com")).to eq(user)
      end
    end

    describe "by not existent email" do
      let(:email) { "wrong@example.com" }

      it do
        expect(repository.find_by_email("test@example.com")).to be_nil
      end
    end
  end

  describe "find user by username" do

    before do
      repository.clear
      user
    end

    let(:email) { "test@example.com" }
    let(:password) { "password" }
    let(:username) { "tester" }
    let(:user) do
      repository.create(
        email: email,
        username: username,
        password: PasswordHelper.create_password(password)
      )
    end

    describe "by existent username" do
      it "retrieves appropriate record" do
        expect(repository.find_by_username("tester")).to eq(user)
      end
    end

    describe "by not existent username" do
      let(:username) { "wrong@example.com" }

      it do
        expect(repository.find_by_username("test@example.com")).to be_nil
      end
    end
  end

end
