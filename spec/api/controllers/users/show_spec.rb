RSpec.describe Api::Controllers::Users::Show, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[] }
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

  describe "show user" do

    before do
      repository.clear
      user
      user2
    end

    it 'is need authentication' do
      response = action.call(params)
      expect(response[0]).to eq 401
    end

    it 'is successful' do
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200
      expect(JSON(response[2][0])["user"]).to include("email" => user.email, "username" => user.username, "bio" => user.bio, "image" => user.image)
      expect(JSON(response[2][0])["user"]["token"]).to eq JWTHelper.decode(user)
    end

    it 'is successful for other token' do
      response2 = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user2)}"))
      expect(response2[0]).to eq 200
      expect(JSON(response2[2][0])["user"]).to include("email" => user2.email, "username" => user2.username, "bio" => user2.bio, "image" => user2.image)
      expect(JSON(response2[2][0])["user"]["token"]).to eq JWTHelper.decode(user2)
    end
  end
end
