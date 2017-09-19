require 'rails_helper'

field_name = 'macaddr'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: '32:01:16:6d:05:ef'
end
