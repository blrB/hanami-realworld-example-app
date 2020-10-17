RSpec.describe Api::Controllers::Users::Login, type: :action do
  let(:repository) { UserRepository.new }
  let(:action) { described_class.new }
  let(:user) {
    repository.create(
      {
        "username": "Jacob",
        "email": "jake@jake.jake",
        "password": PasswordHelper.create_password("jakejake")
      }
    )
  }

  describe "login user" do

    before do
      repository.clear
      user
    end

    it 'is successful' do
      params = JSON('
        {
          "user": {
            "email": "jake@jake.jake",
            "password": "jakejake"
          }
        }
      ')
      response = action.call(params)
      expect(response[0]).to eq 201
      expect(JSON(response[2][0])["user"]).to include( "email" => user.email, "username" => user.username, "bio" => user.bio, "image" => user.image )
      expect(JSON(response[2][0])["user"]["token"]).to eq JWTHelper.decode(user)
    end

    it 'is email other' do
      params = JSON('
        {
          "user": {
            "email": "jake_other@jake.jake",
            "password": "jakejake"
          }
        }
      ')
      response = action.call(params)
      expect(response[0]).to eq 401
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Unauthorized requests'] })
    end

    it 'is password other' do
      params = JSON('
        {
          "user": {
            "email": "jake@jake.jake",
            "password": "jakejake_other"
          }
        }
      ')
      response = action.call(params)
      expect(response[0]).to eq 401
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Unauthorized requests'] })
    end

    it 'is params not valide' do
      params = JSON('
        {
          "user": {
            "email": "jake@jake.jake"
          }
        }
      ')
      response = action.call(params)
      expect(response[0]).to eq 422
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Params not valide'] })
    end

  end
end
