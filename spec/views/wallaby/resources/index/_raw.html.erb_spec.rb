# frozen_string_literal: true

require 'rails_helper'

field_name = 'string'
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    partial_name: 'raw',
    value: '<span>something</span>',
    skip_escaping: true
end
