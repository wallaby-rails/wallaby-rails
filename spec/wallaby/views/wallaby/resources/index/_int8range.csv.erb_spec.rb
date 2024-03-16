# frozen_string_literal: true

require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name, type: :helper do
  it_behaves_like \
    "#{type} csv partial", field_name,
    value: BigDecimal('10')**13..BigDecimal('9') * (10**14)
end
