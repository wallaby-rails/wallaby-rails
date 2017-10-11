require 'rails_helper'

field_name = 'inet'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: IPAddr.new('192.168.1.12'),
    skip_general: true do

    it 'renders the inet' do
      expect(rendered).to include "<code>#{value}</code>"
      expect(rendered).to include "http://ip-api.com/##{value}"
    end
  end
end
