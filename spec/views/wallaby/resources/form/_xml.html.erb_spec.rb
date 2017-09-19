require 'rails_helper'

field_name = 'xml'
xml = <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<note>
<to>Tove</to>
<from>Jani</from>
<heading>Reminder</heading>
<body>Don't forget me this weekend!</body>
</note>
XML
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: xml,
    input_selector: 'textarea',
    content_for: true,
    skip_general: true,
    skip_nil: true do

    it 'initializes the codemirror' do
      textarea = page.at_css('textarea.form-control')
      expect(textarea['data-init']).to eq 'codemirror'
    end

    it 'checks the value' do
      textarea = page.at_css('textarea.form-control')
      expect(textarea['name']).to eq "#{resources_name}[#{field_name}]"
      expect(textarea.content).to eq "\n#{expected_value}"
    end

    context 'when value is nil' do
      let(:value) { nil }

      it 'renders the belongs_to form' do
        textarea = page.at_css('textarea.form-control')
        expect(textarea['name']).to eq "#{resources_name}[#{field_name}]"
        expect(textarea.content).to eq "\n"
      end
    end
  end
end
