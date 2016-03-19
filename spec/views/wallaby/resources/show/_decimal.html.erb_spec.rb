require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/show/decimal.html.erb' }
  let(:value)     { BigDecimal.new(42)**13 / 10**20 }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the decimal' do
    expect(rendered).to eq "12.65437718438866624512\n"
  end

  context 'when value is 0' do
    let(:value) { BigDecimal.new 0 }
    it 'renders the decimal' do
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
