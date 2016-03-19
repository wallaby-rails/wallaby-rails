require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/index/bit.html.erb' }
  let(:value)     { '1' }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders bit' do
    expect(rendered).to eq "  <code>1</code>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
