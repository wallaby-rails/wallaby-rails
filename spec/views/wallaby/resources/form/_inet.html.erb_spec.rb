require 'rails_helper'

field_name = 'inet'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: IPAddr.new('192.168.1.12')
end
