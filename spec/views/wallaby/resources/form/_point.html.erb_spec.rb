require 'rails_helper'

field_name = 'point'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: [3, 4],
    skip_general: true,
    skip_nil: true do
    it 'checks the dates' do
      first_input = page.at_css('.row > div:first .form-control')
      last_input = page.at_css('.row > div:last .form-control')
      expect(first_input['name']).to eq "#{resources_name}[#{field_name}][]"
      expect(first_input['type']).to eq 'number'
      expect(first_input['value']).to eq value.first.to_s
      expect(last_input['name']).to eq "#{resources_name}[#{field_name}][]"
      expect(last_input['type']).to eq 'number'
      expect(last_input['value']).to eq value.last.to_s
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
