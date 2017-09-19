require 'rails_helper'

field_name = 'tsrange'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: Time.zone.parse('2016-03-16 14:55:10 UTC')..Time.zone.parse('2016-03-18 14:55:10 UTC'),
    skip_general: true,
    skip_nil: true do

    it 'checks the numbers' do
      first_input = page.at_css('.row > div:first .form-control')
      last_input = page.at_css('.row > div:last .form-control')
      expect(first_input['name']).to eq "#{resources_name}[#{field_name}][]"
      expect(first_input['type']).to eq 'text'
      expect(first_input['value']).to eq '2016-03-16 14:55:10 UTC'
      expect(last_input['name']).to eq "#{resources_name}[#{field_name}][]"
      expect(last_input['type']).to eq 'text'
      expect(last_input['value']).to eq '2016-03-18 14:55:10 UTC'
    end
  end

  it_behaves_like 'form partial', field_name,
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
