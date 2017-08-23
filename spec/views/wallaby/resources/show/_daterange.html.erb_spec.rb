require 'rails_helper'

partial_name = 'show/daterange'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { Date.new(2014, 2, 11)..Date.new(2014, 2, 12) }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the daterange' do
    expect(rendered).to eq "  <span class=\"from\">2014-02-11</span>\n  ...\n  <span class=\"to\">2014-02-12</span>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
