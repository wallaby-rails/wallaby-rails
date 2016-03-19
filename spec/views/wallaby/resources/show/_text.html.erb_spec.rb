require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/show/text.html.erb' }
  let(:value)     { '<b>this is a text for more than 20 characters</b>' }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the text' do
    expect(rendered).to eq "&lt;b&gt;this is a text for more than 20 characters&lt;/b&gt;\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "<i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
