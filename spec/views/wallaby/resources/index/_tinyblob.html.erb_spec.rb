require 'rails_helper'

field_name = 'tinyblob'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: '010111',
    model_class: AllMysqlType,
    skip_general: true do

    it 'renders the tinyblob' do
      expect(rendered).to include view.muted('tinyblob')
    end
  end
end
