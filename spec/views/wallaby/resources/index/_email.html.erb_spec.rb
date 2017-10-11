require 'rails_helper'

field_name = 'email'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: 'tian@reinteractive.net',
    skip_general: true do

    it 'renders the email' do
      expect(rendered).to include "mailto:#{value}"
    end
  end
end
