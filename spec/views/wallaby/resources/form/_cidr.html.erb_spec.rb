require 'rails_helper'

field_name = 'cidr'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: IPAddr.new('192.168.2.0/24')
end
