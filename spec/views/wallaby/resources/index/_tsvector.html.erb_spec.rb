require 'rails_helper'

partial_name = 'index/tsvector'
describe partial_name do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:page) { Nokogiri::HTML rendered }
  let(:value) { "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'" }
  let(:metadata) { { label: partial_name } }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the tsvector' do
    expect(page.at_css('span:first').inner_html).to eq "'a' 'and' 'ate' '..."
    expect(page.at_css('.modaler__title').inner_html).to eq escape(metadata[:label])
    expect(page.at_css('.modaler__body').inner_html).to eq escape(value)
  end

  context 'when value is less than 20 characters' do
    let(:value) { "'a' 'and' 'ate'" }

    it 'renders the tsvector' do
      expect(rendered).to include h(value)
    end
  end

  context 'when max is set to 50' do
    let(:metadata)  { Hash max: 50 }

    it 'renders the tsvector' do
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
