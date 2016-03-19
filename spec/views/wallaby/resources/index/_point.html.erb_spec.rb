require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/index/point.html.erb' }
  let(:value)     { [ 3, 4 ] }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the point' do
    expect(rendered).to eq "  (<span class=\"x\">3</span>,\n  <span class=\"y\">4</span>)\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
