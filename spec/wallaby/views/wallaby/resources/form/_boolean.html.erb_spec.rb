# frozen_string_literal: true

require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name, type: :helper do
  it_behaves_like \
    "#{type} partial", field_name,
    value: true,
    type: 'radio',
    skip_value_check: true,
    skip_nil: true do
    it 'checks the true radio' do
      true_input = page.at_css('input[value=true]')
      false_input = page.at_css('input[value=false]')
      expect(true_input['checked']).to eq 'checked'
      expect(false_input['checked']).to be_nil
    end
  end

  it_behaves_like \
    "#{type} partial", field_name,
    value: false,
    type: 'radio',
    skip_all: true do
    it 'checks the false radio' do
      true_input = page.at_css('input[value=true]')
      false_input = page.at_css('input[value=false]')
      expect(true_input['checked']).to be_nil
      expect(false_input['checked']).to eq 'checked'
    end
  end

  it_behaves_like \
    "#{type} partial", field_name,
    value: nil,
    type: 'radio',
    skip_all: true do
    it 'doesnt check any radio' do
      true_input = page.at_css('input[value=true]')
      false_input = page.at_css('input[value=false]')
      expect(true_input['checked']).to be_nil
      expect(false_input['checked']).to be_nil
    end
  end
end
