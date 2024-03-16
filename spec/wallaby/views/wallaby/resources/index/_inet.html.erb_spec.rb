# frozen_string_literal: true

require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name, type: :helper do
  it_behaves_like \
    "#{type} partial", field_name,
    value: IPAddr.new('192.168.1.12'),
    skip_general: true do
    it 'renders the inet' do
      expect(rendered).to include "<code>#{value}</code>"
      expect(rendered).to include "http://ip-api.com/##{value}"
    end
  end
end
