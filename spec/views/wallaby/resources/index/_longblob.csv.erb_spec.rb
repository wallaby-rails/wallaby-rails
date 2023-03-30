# frozen_string_literal: true

require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} csv partial", field_name,
    value: '010111',
    model_class: AllMysqlType,
    expected_value: '<longblob>'
end
