require 'rails_helper'

partial_name = 'index/bigint'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{ partial_name }.html.erb" }
  let(:value)     { BigDecimal.new(42)**20 }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the bigint' do
    expect(rendered).to eq "291733167875766667063796853374976.0\n"
  end

  context 'when value is 0' do
    let(:value) { 0 }
    it 'renders the bigint' do
      expect(rendered).to eq "0\n"
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "<i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
