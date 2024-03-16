# frozen_string_literal: true

require 'rails_helper'

type = type_from __FILE__
field_name = 'binary'
describe field_name, type: :helper do
  it_behaves_like \
    "#{type} partial", field_name,
    partial_name: 'active_storage',
    value: true,
    model_class: AllPostgresType,
    skip_general: true
end
