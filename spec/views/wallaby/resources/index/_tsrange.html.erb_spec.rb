require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/index/tsrange.html.erb' }
  let(:value)     { Time.new(2016, 03, 16, 14, 55, 10)..Time.new(2016, 03, 18, 14, 55, 10) }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the tsrange' do
    expect(rendered).to eq "  <span class=\"from\">16 Mar 14:55</span>\n  ...\n  <span class=\"to\">18 Mar 14:55</span>\n  <i title=\"Wed, 16 Mar 2016 14:55:10 -0400 ... Fri, 18 Mar 2016 14:55:10 -0400\" data-toggle=\"tooltip\" data-placement=\"top\" class=\"glyphicon glyphicon-time\"></i>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
