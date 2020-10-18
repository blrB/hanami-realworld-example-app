RSpec.describe Api::Controllers::Tags::Index, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[] }

  describe "create tags" do

    it 'is successful' do
      response = action.call(params)
      expect(response[0]).to eq 200
    end

    it 'is content type json' do
      response = action.call(params)
      expect(response[1]['Content-Type']).to eq CONTENT_TYPE
    end

    it 'is has tags array' do
      response = action.call(params)
      expect(JSON(response[2][0])['tags']).to be_an_instance_of(Array)
    end

  end

end
