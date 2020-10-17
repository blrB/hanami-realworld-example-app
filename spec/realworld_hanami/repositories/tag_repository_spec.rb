RSpec.describe TagRepository, type: :repository do
  let(:repository) { described_class.new }

  describe "list of tags" do

    before do
      repository.clear
    end

    it "retrieves appropriate record" do
      expect(repository.list).to eq []
    end

    it "changed after add" do
      tag = repository.create(name: 'TEST 1')
      expect(repository.list).to eq [tag]
    end
  end

end
