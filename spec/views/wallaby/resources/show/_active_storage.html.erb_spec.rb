# frozen_string_literal: true

require 'rails_helper'

field_name = 'binary'
describe field_name do
  it_behaves_like \
    'index partial', field_name,
    action: 'show/',
    partial_name: 'active_storage',
    value: true,
    model_class: AllPostgresType,
    skip_general: true
end
