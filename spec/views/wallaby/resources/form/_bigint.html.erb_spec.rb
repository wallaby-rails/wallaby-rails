require 'rails_helper'

field_name = 'bigint'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: BigDecimal.new(42)**28,
    type: 'number'
end
