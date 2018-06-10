require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: 0..100,
    skip_general: true,
    skip_nil: true do
    it 'checks the dates' do
      first_input = page.at_css('.row > div:first .form-control')
      last_input = page.at_css('.row > div:last .form-control')
      expect(first_input['name']).to eq "#{resources_name}[#{field_name}][]"
      expect(first_input['type']).to eq 'number'
      expect(first_input['value']).to eq '0'
      expect(last_input['name']).to eq "#{resources_name}[#{field_name}][]"
      expect(last_input['type']).to eq 'number'
      expect(last_input['value']).to eq '100'
    end
  end

  it_behaves_like \
    "#{type} partial", field_name,
    value: [],
    skip_all: true do
    it 'renders empty range' do
      first_input = page.at_css('.row > div:first .form-control')
      last_input = page.at_css('.row > div:last .form-control')
      expect(first_input['value']).to be_nil
      expect(last_input['value']).to be_nil
    end
  end
end
