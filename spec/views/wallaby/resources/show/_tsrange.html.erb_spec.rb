require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/show/tsrange.html.erb' }
  let(:value)     { Time.zone.parse('2016-03-16 14:55:10 UTC')..Time.zone.parse('2016-03-18 14:55:10 UTC') }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the tsrange' do
    expect(rendered).to eq "  <span class=\"from\">Wed, 16 Mar 2016 14:55:10 +0000</span>\n  ...\n  <span class=\"to\">Fri, 18 Mar 2016 14:55:10 +0000</span>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
