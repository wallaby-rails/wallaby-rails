require 'rails_helper'

field_name = 'int4range'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: 0..100,
    skip_general: true do

    it 'renders the int4range' do
      expect(rendered).to include '<span class="from">0</span>'
      expect(rendered).to include '<span class="to">100</span>'
    end
  end
end
