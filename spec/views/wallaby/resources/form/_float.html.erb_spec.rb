require 'rails_helper'

field_name = 'float'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: 88.8888,
    type: 'number'
end
