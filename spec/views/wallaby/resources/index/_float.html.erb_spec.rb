require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/index/float.html.erb' }
  let(:value)     { 88.8888 }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the float' do
    expect(rendered).to eq "88.8888\n"
  end

  context 'when value is 0' do
    let(:value) { 0 }
    it 'renders the float' do
      expect(rendered).to eq "0.0\n"
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "<i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
