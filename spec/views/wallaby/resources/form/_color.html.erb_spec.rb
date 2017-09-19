require 'rails_helper'

field_name = 'string'
partial_name = 'color'
describe partial_name do
  it_behaves_like 'form partial', field_name,
    value: '#000000',
    partial_name: partial_name,
    input_selector: 'input.form-control' do
    it 'initializes the colorpicker' do
      input = page.at_css('input.form-control')
      expect(input['data-init']).to eq 'colorpicker'
    end
  end
end
