require 'rails_helper'

field_name = 'lseg'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: '[(1,2),(3,4)]'
end
