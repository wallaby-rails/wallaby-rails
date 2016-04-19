require 'rails_helper'

partial_name = 'show/ltree'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{ partial_name }.html.erb" }
  let(:value)     { 'Top.Science.Astronomy.Cosmology' }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the ltree' do
    expect(rendered).to eq "Top.Science.Astronomy.Cosmology\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "<i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
