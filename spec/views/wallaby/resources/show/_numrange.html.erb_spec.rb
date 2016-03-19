require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/show/numrange.html.erb' }
  let(:value)     { 1..100 }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the numrange' do
    expect(rendered).to eq "  <span class=\"from\">1</span>\n  ...\n  <span class=\"to\">100</span>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
