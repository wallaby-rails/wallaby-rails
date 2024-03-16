# frozen_string_literal: true

require 'rails_helper'

field_name = Rails::VERSION::MAJOR >= 5 ? field_name_from(__FILE__) : 'string'
type = type_from __FILE__
describe field_name, type: :helper do
  it_behaves_like \
    "#{type} partial", field_name,
    value: '((1,2),(3,4))',
    partial_name: 'polygon',
    skip_general: true,
    code_value: true,
    max_length: 20,
    max_value: '((1.0000008,2.0000008),(3.0000008,4.0000008))',
    modal_value: true
end
