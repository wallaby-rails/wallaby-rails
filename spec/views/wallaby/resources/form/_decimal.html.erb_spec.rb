require 'rails_helper'

field_name = 'decimal'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: BigDecimal.new(42)**13 / 10**20,
    type: 'number'
end
