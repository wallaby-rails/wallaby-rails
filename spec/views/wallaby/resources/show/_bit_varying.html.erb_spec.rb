require 'rails_helper'

partial_name = 'show/bit_varying'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { '1101' }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders bit_varying' do
    expect(rendered).to eq "  <code>1101</code>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
