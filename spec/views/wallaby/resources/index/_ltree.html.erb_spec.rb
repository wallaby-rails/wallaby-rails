require 'rails_helper'

partial_name = 'index/ltree'
describe partial_name do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:page) { Nokogiri::HTML rendered }
  let(:value) { 'Top.Science.Astronomy.Cosmology' }
  let(:metadata) { { label: partial_name } }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the ltree' do
    expect(page.at_css('span:first').inner_html).to eq 'Top.Science.Astro...'
    expect(page.at_css('.modaler__title').inner_html).to eq escape(metadata[:label])
    expect(page.at_css('.modaler__body').inner_html).to eq escape(value)
  end

  context 'when value is less than 20 characters' do
    let(:value) { 'Top.Science' }

    it 'renders the ltree' do
      expect(rendered).to include h(value)
    end
  end

  context 'when max is set to 40' do
    let(:metadata) { Hash max: 40 }

    it 'renders the ltree' do
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
