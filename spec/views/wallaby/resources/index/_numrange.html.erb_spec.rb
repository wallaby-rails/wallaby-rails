require 'rails_helper'

field_name = 'numrange'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: 0..100,
    skip_general: true do

    it 'renders the numrange' do
      expect(rendered).to include '<span class="from">0</span>'
      expect(rendered).to include '<span class="to">100</span>'
    end
  end
end
