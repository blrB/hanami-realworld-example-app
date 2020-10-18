RSpec.describe Api::Controllers::Users::Create, type: :action do
  let(:action) { described_class.new }

  before(:context) do
    UserRepository.new.clear
  end

  describe "create user" do

    it 'is successful' do
      expect(UserRepository.new.users.count).to eq 0
      params = JSON('
        {
          "user":{
            "username": "Jacob",
            "email": "jake@jake.jake",
            "password": "jakejake"
          }
        }
      ')
      response = action.call(params)
      expect(response[0]).to eq 201
      expect(JSON(response[2][0])["user"]).to include( "email" => "jake@jake.jake", "username" => "Jacob", "bio" => nil, "image" => nil )
      expect(JSON(response[2][0])["user"]["token"]).to be_an_instance_of(String)
      expect(UserRepository.new.users.count).to eq 1
    end

    it 'is email already registered' do
      expect(UserRepository.new.users.count).to eq 1
      params = JSON('
        {
          "user":{
            "username": "Jacob2",
            "email": "jake@jake.jake",
            "password": "jakejake2"
          }
        }
      ')
      response = action.call(params)
      expect(response[0]).to eq 403
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Email already registered'] })
    end

    it 'is username already registered' do
      params = JSON('
        {
          "user":{
            "username": "Jacob",
            "email": "jake3@jake.jake",
            "password": "jakejake3"
          }
        }
      ')
      response = action.call(params)
      expect(response[0]).to eq 403
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Username already registered'] })
    end

    it 'is params not valide' do
      params = JSON('
        {
          "user":{
            "email": "jake4@jake.jake",
            "password": "jakejake4"
          }
        }
      ')
      response = action.call(params)
      expect(response[0]).to eq 422
      expect(JSON(response[2][0])).to include("errors" => { "body" => ['Params not valide'] })
    end
  end
end
