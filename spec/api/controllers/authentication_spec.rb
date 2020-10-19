RSpec.describe Api::Controllers::Authentication, type: :action do
  let(:action) { Api::Controllers::Users::Show.new }
  let(:params) { Hash[] }
  let(:repository) { UserRepository.new }
  let(:user) { repository.create(FactoryBot.attributes_for(:user)) }
  let(:user2) { repository.create(FactoryBot.attributes_for(:user2)) }

  describe "check authentication" do

    before do
      repository.clear
      user
      user2
    end

    it 'is need authentication' do
      response = action.call(params)
      expect(response[0]).to eq 401
      expect(action.exposures[:current_user]).to be_nil
    end

    it 'is successful' do
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200
      expect(action.exposures[:current_user]).to eq(user)
    end

    it 'is successful for other token' do
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user2)}"))
      expect(response[0]).to eq 200
      expect(action.exposures[:current_user]).to eq(user2)
    end
  end
end
