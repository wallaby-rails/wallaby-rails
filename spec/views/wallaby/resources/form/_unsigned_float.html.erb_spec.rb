require 'rails_helper'

field_name = 'unsigned_float'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: 88.8888,
    type: 'number',
    model_class: AllMysqlType
end
