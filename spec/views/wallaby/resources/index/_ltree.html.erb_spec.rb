require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: 'Top.Science',
    skip_general: true,
    max_length: 20,
    max_value: 'Top.Science.Astronomy.Cosmology'
end
