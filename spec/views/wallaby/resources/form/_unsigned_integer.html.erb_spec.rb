require 'rails_helper'

field_name = 'unsigned_integer'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: 100,
    type: 'number',
    model_class: AllMysqlType
end
