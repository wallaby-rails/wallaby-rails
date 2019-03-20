require 'rails_helper'

field_name = 'binary'
type = type_from __FILE__
klass = cell_class_from __FILE__
describe klass, type: :view do
  it_behaves_like \
    "index cell", field_name,
    value: true,
    model_class: AllPostgresType,
    skip_general: true
end
