require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
klass = cell_class_from __FILE__
describe klass, type: :view do
  it_behaves_like \
    "#{type} cell", field_name,
    value: 'Top.Science',
    max_length: 20,
    max_value: 'Top.Science.Astronomy.Cosmology'
end
