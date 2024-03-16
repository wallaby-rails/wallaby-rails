# frozen_string_literal: true

require 'rails_helper'

partial_name = 'show/xml'
describe partial_name, type: :view do
  let(:partial)   { "wallaby/resources/#{partial_name}" }
  let(:value)     do
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

  let(:metadata) { {} }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the text' do
    expect(rendered).to include "<pre>#{h value}</pre>"
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
