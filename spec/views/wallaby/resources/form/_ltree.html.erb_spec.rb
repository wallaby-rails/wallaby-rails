require 'rails_helper'

field_name = 'ltree'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: 'Top.Science.Astronomy.Cosmology'
end
