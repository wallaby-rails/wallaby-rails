require 'rails_helper'

field_name = 'string'
type = type_from __FILE__
klass = cell_class_from __FILE__
describe klass, type: :view do
  it_behaves_like \
    "#{type} cell", field_name,
    value: '<span>something</span>',
    skip_escaping: true
end
