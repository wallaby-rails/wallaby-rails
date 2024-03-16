# frozen_string_literal: true

require 'rails_helper'

field_name = 'binary'
type = type_from __FILE__
describe field_name, type: :helper do
  it_behaves_like \
    "#{type} partial", field_name,
    value: '001111000001',
    partial: 'file',
    type: 'file',
    model_class: AllMysqlType,
    input_selector: 'input.sr-only',
    skip_value_check: true
end
