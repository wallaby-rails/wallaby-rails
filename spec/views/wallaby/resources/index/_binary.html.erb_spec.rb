require 'rails_helper'

field_name = 'binary'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: '010111',
    skip_general: true do

    it 'renders the binary' do
      expect(rendered).to include view.muted('binary')
    end
  end
end
