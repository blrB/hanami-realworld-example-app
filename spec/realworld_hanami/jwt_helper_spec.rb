RSpec.describe JWTHelper, type: :action do
  let(:helper) { described_class }
  let(:repository) { UserRepository.new }
  let(:user) { repository.create(FactoryBot.attributes_for(:user)) }

  describe "jwt helper works" do

    before do
      repository.clear
      user
    end

    it 'test decode/encode/user_id' do
      token = helper.decode(user)
      payload = helper.encode(token)
      user_id = helper.user_id(payload)

      expect(user_id).to eq user.id
    end

  end
end
