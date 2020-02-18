require 'rails_helper'

field_name = Rails::VERSION::MAJOR >= 5 ? field_name_from(__FILE__) : 'string'
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: '010111',
    partial_name: 'tinyblob',
    model_class: AllMysqlType,
    skip_general: true do
    it 'renders the tinyblob' do
      expect(rendered).to include view.muted('tinyblob')
    end
  end
end
