require 'rails_helper'

partial_name = 'show/boolean'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { true }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the boolean' do
    expect(rendered).to include view.fa_icon('check-square')
  end

  context 'when value is false' do
    let(:value) { false }

    it 'renders the boolean' do
      expect(rendered).to include view.fa_icon('square')
    end
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
