RSpec.describe Api::Controllers::Users::Update, type: :action do
  let(:action) { described_class.new }
  let(:repository) { UserRepository.new }
  let(:user) { repository.create(FactoryBot.attributes_for(:user)) }
  let(:user2) { repository.create(FactoryBot.attributes_for(:user2)) }

  describe "update user" do

    before do
      repository.clear
      user
      user2
    end

    it 'is need authentication' do
      response = action.call({})
      expect(response[0]).to eq 401
    end

    it 'is successful' do
      params = JSON('
        {
          "user": {
            "email": "jake_new@jake.jake"
          }
        }
      ')
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200
      updated_user = repository.find(user.id)
      expect(JSON(response[2][0])["user"]).to include("email" => updated_user.email, "username" => updated_user.username, "bio" => updated_user.bio, "image" => updated_user.image)
      expect(JSON(response[2][0])["user"]["token"]).to eq JWTHelper.decode(updated_user)
    end

    it 'is unsuccessful (rewrite email)' do
      params = JSON('
        {
          "user": {
            "email": "jake2@jake.jake"
          }
        }
      ')
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 403
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Email already registered'] })
    end

    it 'is unsuccessful (rewrite username)' do
      params = JSON('
        {
          "user": {
            "username": "Jacob2"
          }
        }
      ')
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 403
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Username already registered'] })
    end


    it 'is params not valide' do
      params = JSON('
        {
          "new_user_params": {
            "email": "jake_new@jake.jake"
          }
        }
      ')
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 422
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Params not valide'] })
    end

  end
end
