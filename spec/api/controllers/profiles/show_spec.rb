RSpec.describe Api::Controllers::Profiles::Show, type: :action do
  let(:action) { described_class.new }
  let(:params) { { username: "Jacob2" } }
  let(:repository) { UserRepository.new }
  let(:user) {
    repository.create(
      {
        "username": "Jacob",
        "email": "jake@jake.jake",
        "password": PasswordHelper.create_password("jakejake")
      }
    )
  }
  let(:user2) {
    repository.create(
      {
        "username": "Jacob2",
        "email": "jake2@jake.jake",
        "password": PasswordHelper.create_password("jakejake2")
      }
    )
  }

  describe "show profile" do

    before do
      repository.clear
      user
      user2
    end

    it 'is no need authentication' do
      response = action.call(params)
      expect(response[0]).to eq 200
    end

    it 'is successful' do
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200
      expect(JSON(response[2][0])["profile"]).to include("username" => user2.username, "bio" => user2.bio, "image" => user2.image)
      expect(JSON(response[2][0])["profile"]["following"]).to eq false
    end
  end

end
