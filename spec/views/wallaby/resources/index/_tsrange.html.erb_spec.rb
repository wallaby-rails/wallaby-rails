require 'rails_helper'

partial_name = 'index/tsrange'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { Time.zone.parse('2016-03-16 14:55:10 UTC')..Time.zone.parse('2016-03-18 14:55:10 UTC') }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the tsrange' do
    expect(rendered).to include '<span class="from">16 Mar 14:55</span>'
    expect(rendered).to include '<span class="to">18 Mar 14:55</span>'
    expect(rendered).to include 'title="Wed, 16 Mar 2016 14:55:10 +0000 ... Fri, 18 Mar 2016 14:55:10 +0000"'
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
