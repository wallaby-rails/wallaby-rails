# frozen_string_literal: true

require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: "'a' 'and' 'ate'",
    max_length: 20,
    max_value: "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'",
    modal_value: true
end
