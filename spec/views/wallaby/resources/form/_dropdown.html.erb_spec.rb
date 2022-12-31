# frozen_string_literal: true
require 'rails_helper'

field_name = 'integer'
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: 1,
    type: 'select',
    partial_name: 'dropdown',
    metadata: {
      choices: [1, 2]
    },
    skip_general: true,
    skip_nil: true do
      it 'renders the dropdown' do
        input = page.at_css('.form-group .form-control')
        expect(input['name']).to eq "#{resources_name}[#{field_name}]"
        expect(input.name).to eq 'select'

        options = input.css('option')
        expect(options.length).to eq 2
        expect(options[0]['selected']).to eq 'selected'
        expect(options[0]['value']).to eq '1'
        expect(options[1]['selected']).to be_blank
        expect(options[1]['value']).to eq '2'
      end

      context 'when it is nil' do
        let(:value) { nil }

        it 'renders the dropdown' do
          input = page.at_css('.form-group .form-control')
          expect(input['name']).to eq "#{resources_name}[#{field_name}]"
          expect(input.name).to eq 'select'

          options = input.css('option')
          expect(options.length).to eq 2
          expect(options[0]['selected']).to be_blank
          expect(options[0]['value']).to eq '1'
          expect(options[1]['selected']).to be_blank
          expect(options[1]['value']).to eq '2'
        end
      end
    end
end
