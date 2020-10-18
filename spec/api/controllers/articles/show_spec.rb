RSpec.describe Api::Controllers::Articles::Show, type: :action do
  let(:action) { described_class.new }
  let(:params) { {slug: '404'} }

  it 'is successful' do
    response = action.call(params)
    expect(response[0]).to eq 404
  end
end
