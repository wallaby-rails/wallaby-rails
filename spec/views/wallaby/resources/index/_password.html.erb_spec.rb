# frozen_string_literal: true

require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: 'Password*****',
    skip_general: true do
    it 'renders the password' do
      expect(rendered).to include '<code>********</code>'
    end
  end
end
