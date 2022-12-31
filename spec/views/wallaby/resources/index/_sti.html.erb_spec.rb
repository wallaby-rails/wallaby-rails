# frozen_string_literal: true
require 'rails_helper'

field_name = 'type'
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    partial_name: 'sti',
    model_class: Person,
    value: 'Customer',
    max_length: 20,
    max_value: 'HumanResource::Manager',
    max_title: true
end
