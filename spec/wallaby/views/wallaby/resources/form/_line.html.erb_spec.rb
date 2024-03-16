# frozen_string_literal: true

require 'rails_helper'

if Rails::VERSION::MAJOR >= 5
  field_name = 'string'
  type = type_from __FILE__
  describe field_name, type: :helper do
    it_behaves_like \
      "#{type} partial", field_name,
      value: '{1,2,5}'
  end
end
