require 'rails_helper'

partial_name = 'index/color'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { '#000000' }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the string' do
    expect(rendered).to eq "  <span style=\"background-color: #000000;\" class=\"color-square\"></span><span class=\"text-uppercase\">#000000</span>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
