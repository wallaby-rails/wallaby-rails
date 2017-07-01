require 'rails_helper'

partial_name = 'index/daterange'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { Date.new(2014, 2, 11)..Date.new(2014, 2, 12) }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the daterange' do
    expect(rendered).to eq "  <span class=\"from\">Feb 11</span>\n  ...\n  <span class=\"to\">Feb 12</span>\n  <i title=\"2014-02-11 ... 2014-02-12\" data-toggle=\"tooltip\" data-placement=\"top\" class=\"fa fa-clock-o\"></i>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
