# frozen_string_literal: true

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

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name, type: :helper do
  it_behaves_like \
    "#{type} partial", field_name,
    value: '<xml></xml>',
    max_length: 20,
    max_value: xml,
    modal_value: true
end
