require 'rails_helper'

if Rails::VERSION::MAJOR >= 5
  field_name = field_name_from __FILE__
  type = type_from __FILE__
  describe field_name do
    it_behaves_like \
      "#{type} partial", field_name,
      value: '((1,2),(3,4))',
      input_selector: '.form-group input'
  end
end
