require 'rails_helper'

field_name = 'string'
partial_name = 'email'
describe partial_name do
  it_behaves_like 'form partial', field_name,
    value: 'tian@reinteractive.net',
    type: 'email',
    partial_name: partial_name,
    input_selector: 'input.form-control' do
  end
end
