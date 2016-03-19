require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/index/string.html.erb' }
  let(:value)     { 'this is a text for more than 20 characters' }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the string' do
    expect(rendered).to eq "    <span>this is a text fo...</span>\n    <i title=\"this is a text for more than 20 characters\" data-toggle=\"tooltip\" data-placement=\"top\" class=\"glyphicon glyphicon-info-sign\"></i>\n"
  end

  context 'when value is less than 20 characters' do
    let(:value) { '12345678901234567890' }
    it 'renders the string' do
      expect(rendered).to eq "    12345678901234567890\n"
    end
  end

  context 'when max is set to 50' do
    let(:metadata)  { Hash max: 50 }
    it 'renders the string' do
      expect(rendered).to eq "    this is a text for more than 20 characters\n"
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
