require 'rails_helper'

field_name = 'type'
klass = cell_class_from __FILE__
describe klass, type: :view do
  it_behaves_like \
    'index cell', field_name,
    partial_name: 'sti',
    model_class: Person,
    value: 'Customer',
    max_length: 20,
    max_value: 'HumanResource::Manager',
    max_title: true
end
