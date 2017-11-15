require 'rails_helper'

partial_name = 'color'
field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: '#000000',
    partial_name: partial_name,
    input_selector: 'input.form-control' do
    it 'initializes the colorpicker' do
      input = page.at_css('input.form-control')
      expect(input['data-init']).to eq 'colorpicker'
    end
  end
end
