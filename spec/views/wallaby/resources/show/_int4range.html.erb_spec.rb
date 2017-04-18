require 'rails_helper'

partial_name = 'show/int4range'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { 0..100 }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the int4range' do
    expect(rendered).to eq "  <span class=\"from\">0</span>\n  ...\n  <span class=\"to\">100</span>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
