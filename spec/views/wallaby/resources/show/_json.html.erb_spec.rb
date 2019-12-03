require 'rails_helper'

partial_name = 'show/json'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:metadata)  { {} }
  let(:value) do
    {
      'kind' => 'user_renamed',
      'change' => %w(jack john)
    }.to_json
  end

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the json' do
    expect(rendered).to include h(value)
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
