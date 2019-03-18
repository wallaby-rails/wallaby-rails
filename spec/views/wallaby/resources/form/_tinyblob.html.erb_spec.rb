require 'rails_helper'

if Rails::VERSION::MAJOR >= 5
  field_name = field_name_from __FILE__
  type = type_from __FILE__
  describe field_name do
    it_behaves_like \
      "#{type} partial", field_name,
      value: '001111000001',
      type: 'file',
      model_class: AllMysqlType,
      input_selector: 'input.sr-only',
      skip_value_check: true
  end
end
