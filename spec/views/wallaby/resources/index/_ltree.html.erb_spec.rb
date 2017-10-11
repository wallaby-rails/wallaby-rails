require 'rails_helper'

field_name = 'ltree'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: 'Top.Science',
    skip_general: true,
    max_length: 20,
    max_value: 'Top.Science.Astronomy.Cosmology'
end
