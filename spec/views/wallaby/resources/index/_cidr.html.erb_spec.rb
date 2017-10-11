require 'rails_helper'

field_name = 'cidr'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: IPAddr.new('192.168.2.0/24'),
    skip_general: true do

    it 'renders the cidr' do
      expect(rendered).to include "<code>#{value}</code>"
      expect(rendered).to include "http://ip-api.com/##{value}"
    end
  end
end
