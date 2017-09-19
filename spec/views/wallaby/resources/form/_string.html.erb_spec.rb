require 'rails_helper'

field_name = 'string'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: '<b>this is a text for more than 20 characters</b>'
end
