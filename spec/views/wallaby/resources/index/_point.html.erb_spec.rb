require 'rails_helper'

field_name = 'point'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: [3, 4],
    skip_general: true do
    it 'renders the point' do
      expect(rendered).to eq "  (<span class=\"x\">3</span>,\n  <span class=\"y\">4</span>)\n"
    end
  end
end
