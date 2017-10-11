require 'rails_helper'

field_name = 'color'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: '#000000',
    skip_general: true do

    it 'renders the color' do
      expect(rendered).to include "background-color: #{value};"
      expect(rendered).to include "<span class=\"text-uppercase\">#{value}</span>"
    end
  end
end
