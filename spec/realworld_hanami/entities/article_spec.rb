RSpec.describe Article, type: :entity do
  let(:class_entity) { described_class }

  describe "check authentication" do
    it 'is generate slug' do
      expect(class_entity.title_to_slug('test')).to eq 'test'
      expect(class_entity.title_to_slug('test test')).to eq 'test-test'
      expect(class_entity.title_to_slug('test test (UPDATED)')).to eq 'test-test-updated'
    end
  end
  
end
