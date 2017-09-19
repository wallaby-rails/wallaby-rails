require 'rails_helper'

field_name = 'line'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: '{1,2,5}'
end
