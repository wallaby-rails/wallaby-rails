require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/index/int8range.html.erb' }
  let(:value)     { BigDecimal.new(10)**13..BigDecimal(9)*10**14 }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the int8range' do
    expect(rendered).to eq "  <span class=\"from\">10000000000000.0</span>\n  ...\n  <span class=\"to\">900000000000000.0</span>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
