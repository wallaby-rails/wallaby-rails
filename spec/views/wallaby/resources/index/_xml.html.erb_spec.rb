require 'rails_helper'

xml = <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<note>
  <to>Tove</to>
  <from>Jani</from>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>
XML

field_name = 'xml'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: '<xml></xml>',
    max_length: 20,
    max_value: xml,
    modal_value: true
end
