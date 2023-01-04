# frozen_string_literal: true
require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: BigDecimal('42')**13 / 10**20,
    type: 'number',
    model_class: AllMysqlType
end
