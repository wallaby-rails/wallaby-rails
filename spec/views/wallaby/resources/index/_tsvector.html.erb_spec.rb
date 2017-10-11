require 'rails_helper'

field_name = 'tsvector'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: "'a' 'and' 'ate'",
    max_length: 20,
    max_value: "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'",
    modal_value: true
end
