require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: '<b>this is a text for more than 20 characters</b>',
    input_selector: 'textarea',
    model_class: AllMysqlType,
    content_for: true,
    skip_general: true,
    skip_nil: true do
    it 'initializes the summernote' do
      textarea = page.at_css('textarea.form-control')
      expect(textarea['data-init']).to eq 'summernote'
    end

    it 'checks the value' do
      textarea = page.at_css('textarea.form-control')
      expect(textarea['name']).to eq "#{resources_name}[#{field_name}]"
      expect(textarea.content).to eq "\n#{expected_value}"
    end

    context 'when value is nil' do
      let(:value) { nil }

      it 'renders the belongs_to form' do
        textarea = page.at_css('textarea.form-control')
        expect(textarea['name']).to eq "#{resources_name}[#{field_name}]"
        expect(textarea.content).to eq "\n"
      end
    end
  end
end
