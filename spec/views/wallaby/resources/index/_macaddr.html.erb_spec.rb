require 'rails_helper'

partial_name = 'index/macaddr'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { '32:01:16:6d:05:ef' }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the macaddr' do
    expect(rendered).to include '<code>32:01:16:6d:05:ef</code>'
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
