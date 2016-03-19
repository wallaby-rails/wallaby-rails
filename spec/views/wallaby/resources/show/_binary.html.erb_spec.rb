require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/show/binary.html.erb' }
  let(:value)     { double }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders na' do
    expect(rendered).to eq "<i class=\"text-muted\">&lt;n/a&gt;</i>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "<i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
