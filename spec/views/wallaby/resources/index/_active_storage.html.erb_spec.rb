require 'rails_helper'

field_name = 'binary'
type = type_from __FILE__
describe klass do
  it_behaves_like \
    "#{type} partial", field_name,
    partial_name: 'active_storage',
    value: true,
    model_class: AllPostgresType,
    skip_general: true
end
