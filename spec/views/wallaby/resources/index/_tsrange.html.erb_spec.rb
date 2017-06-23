require 'rails_helper'

partial_name = 'index/tsrange'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { Time.zone.parse('2016-03-16 14:55:10 UTC')..Time.zone.parse('2016-03-18 14:55:10 UTC') }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the tsrange' do
    expect(rendered).to eq "  <span class=\"from\">16 Mar 14:55</span>\n  ...\n  <span class=\"to\">18 Mar 14:55</span>\n  <i title=\"Wed, 16 Mar 2016 14:55:10 +0000 ... Fri, 18 Mar 2016 14:55:10 +0000\" data-toggle=\"tooltip\" data-placement=\"top\" class=\"fa fa-clock-o\"></i>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
