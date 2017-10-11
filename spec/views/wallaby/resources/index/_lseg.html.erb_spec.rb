require 'rails_helper'

field_name = 'lseg'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: '[(1,2),(3,4)]',
    skip_general: true,
    code_value: true,
    max_length: 20,
    max_value: '[(1.0000008,2.0000008),(3.0000008,4.0000008)]',
    max_title: true
end
