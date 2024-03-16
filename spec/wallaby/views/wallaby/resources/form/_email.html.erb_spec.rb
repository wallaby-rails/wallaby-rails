# frozen_string_literal: true

require 'rails_helper'

partial_name = 'email'
field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name, type: :helper do
  it_behaves_like \
    "#{type} partial", field_name,
    value: 'tian@reinteractive.net',
    type: 'email',
    partial_name: partial_name,
    input_selector: 'input.form-control'
end
