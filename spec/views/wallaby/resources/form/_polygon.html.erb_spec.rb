require 'rails_helper'

field_name = 'polygon'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: '((1,2),(3,4))',
    input_selector: '.form-group input'
end
