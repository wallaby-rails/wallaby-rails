require 'rails_helper'

partial_name = 'index/daterange'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { Date.new(2014, 2, 11)..Date.new(2014, 2, 12) }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the daterange' do
    expect(rendered).to include '<span class="from">Feb 11</span>'
    expect(rendered).to include '<span class="to">Feb 12</span>'
    expect(rendered).to include 'title="2014-02-11 ... 2014-02-12"'
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
