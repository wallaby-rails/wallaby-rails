require 'rails_helper'

field_name = 'money'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: 100.88
end
