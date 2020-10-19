RSpec.describe PasswordHelper, type: :action do
  let(:helper) { described_class }
  let(:repository) { UserRepository.new }
  let(:user) { repository.create(FactoryBot.attributes_for(:user)) }

  describe "jwt helper works" do

    before do
      repository.clear
      user
    end

    it 'test create_password/valid_password?' do
      expect(helper.valid_password?("", user)).to eq false
      expect(helper.valid_password?("jakEjake", user)).to eq false
      expect(helper.valid_password?("jakejake2", user)).to eq false
      expect(helper.valid_password?("jakejake", user)).to eq true
    end

  end
end

