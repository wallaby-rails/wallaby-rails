require 'rails_helper'

partial_name = 'index/xml'
describe partial_name do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:page) { Nokogiri::HTML rendered }
  let(:metadata) { { label: partial_name } }
  let(:value) do
<<-XML
<?xml version="1.0" encoding="UTF-8"?>
<note>
  <to>Tove</to>
  <from>Jani</from>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>
XML
  end

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the text' do
    expect(page.at_css('code').inner_html).to eq '&lt;?xml version="1....'
    expect(page.at_css('.modaler__title').inner_html).to eq escape(metadata[:label])
    expect(page.at_css('.modaler__body').inner_html).to eq "<pre>#{escape(value)}</pre>"
  end

  context 'when xml is less then 20' do
    let(:value) { '<xml></xml>' }

    it 'renders the xml' do
      expect(rendered).to include h(value)
    end
  end

  context 'when max is set to 200' do
    let(:metadata) { Hash max: 200 }

    it 'renders the xml' do
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
