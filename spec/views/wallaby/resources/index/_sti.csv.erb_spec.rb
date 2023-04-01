# frozen_string_literal: true

require 'rails_helper'

field_name = 'type'
describe field_name do
  it_behaves_like \
    'index csv partial', field_name,
    partial_name: 'sti',
    model_class: Person,
    value: 'Customer'
end
