RSpec.describe Api::Controllers::CorsHeaders, type: :action do
  let(:action) { Api::Controllers::Users::Show.new }
  let(:params) { Hash[] }
  let(:repository) { UserRepository.new }
  let(:user) { repository.create(FactoryBot.attributes_for(:user)) }

  describe "check authentication" do

    before do
      repository.clear
      user
    end


    it 'is successful' do
      response = action.call(params.merge('HTTP_AUTHORIZATION' => "Token #{JWTHelper.decode(user)}"))
      expect(response[0]).to eq 200
      expect(response[1]).to include({
        'Access-Control-Allow-Origin' => ENV['CORS_ALLOW_ORIGIN'],
        'Access-Control-Allow-Methods' => ENV['CORS_ALLOW_METHODS'],
        'Access-Control-Allow-Headers' => ENV['CORS_ALLOW_HEADERS']
      })
    end
  end
end
