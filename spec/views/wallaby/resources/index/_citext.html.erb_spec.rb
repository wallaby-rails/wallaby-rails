require 'rails_helper'

partial_name = 'index/citext'
describe partial_name do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:page) { Nokogiri::HTML rendered }
  let(:value) { "<b>this's a text for more than 20 characters</b>" }
  let(:metadata) { { label: partial_name } }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the text' do
    expect(page.at_css('span:first').inner_html).to eq "&lt;b&gt;this's a text ..."
    expect(page.at_css('.modaler__title').inner_html).to eq escape(metadata[:label])
    expect(page.at_css('.modaler__body').inner_html).to eq escape(value)
  end

  context 'when max is set to 200' do
    let(:metadata)  { Hash max: 200 }
    it 'renders the text' do
      expect(rendered).to include h(value)
    end
  end

  context 'when value is less than 20 characters' do
    let(:value) { '<b>1234567890123</b>' }
    it 'renders the text' do
      expect(rendered).to include h(value)
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
