# frozen_string_literal: true

require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name, type: :helper do
  it_behaves_like \
    "#{type} partial", field_name,
    value: 'Top.Science',
    max_length: 20,
    max_value: 'Top.Science.Astronomy.Cosmology'
end
