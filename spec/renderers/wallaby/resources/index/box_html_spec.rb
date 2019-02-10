require 'rails_helper'

if Rails::VERSION::MAJOR >= 5
  field_name = field_name_from __FILE__
  type = type_from __FILE__
  klass = cell_class_from __FILE__
  describe klass, type: :view do
    it_behaves_like \
      "#{type} cell", field_name,
      value: '(1,2),(3,4)',
      skip_general: true,
      code_value: true,
      max_length: 20,
      max_value: '(1.0000008,2.00000008),(3.99999999,4.5555555555)',
      max_title: true
  end
end
