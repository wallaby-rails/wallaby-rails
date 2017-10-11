require 'rails_helper'

field_name = 'password'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: 0..100,
    skip_general: true do

    it 'renders the password' do
      expect(rendered).to include '<code>********</code>'
    end
  end
end
