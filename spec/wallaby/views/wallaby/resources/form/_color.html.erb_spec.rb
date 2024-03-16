# frozen_string_literal: true

require 'rails_helper'

partial_name = 'color'
field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name, type: :helper do
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
