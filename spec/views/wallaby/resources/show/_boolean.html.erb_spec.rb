require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/show/boolean.html.erb' }
  let(:value)     { true }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the boolean' do
    expect(rendered).to eq "  <i class=\"glyphicon glyphicon-check\"></i>\n"
  end

  context 'when value is false' do
    let(:value) { false }
    it 'renders the boolean' do
      expect(rendered).to eq "  <i class=\"glyphicon glyphicon-unchecked\"></i>\n"
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
