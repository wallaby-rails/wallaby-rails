require 'rails_helper'

field_name = 'type'
describe field_name do
  it_behaves_like \
    'index partial', field_name,
    partial_name: 'sti',
    model_class: Person,
    value: 'Customer',
    skip_general: true,
    max_length: 20,
    max_value: 'HumanResource::Manager',
    max_title: true
end
