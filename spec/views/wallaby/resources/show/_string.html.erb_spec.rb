require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/show/string.html.erb' }
  let(:value)     { 'this is a text for more than 20 characters' }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the string' do
    expect(rendered).to eq "this is a text for more than 20 characters\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "<i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
