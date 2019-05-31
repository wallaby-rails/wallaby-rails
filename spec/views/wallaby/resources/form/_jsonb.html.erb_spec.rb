require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: {
      'kind' => 'user_renamed',
      'change' => %w(jack john)
    },
    expected_value: "\n{\n  \"kind\": \"user_renamed\",\n  \"change\": [\n    \"jack\",\n    \"john\"\n  ]\n}",
    input_selector: 'textarea',
    content_for: true,
    skip_general: true,
    skip_nil: true do
    it 'initializes the codemirror' do
      textarea = page.at_css('textarea.form-control')
      expect(textarea['data-init']).to eq 'codemirror'
    end

    it 'checks the value' do
      textarea = page.at_css('textarea.form-control')
      expect(textarea['name']).to eq "#{resources_name}[#{field_name}]"
      expect(textarea.content).to eq expected_value
    end

    context 'when value is nil' do
      let(:value) { nil }

      it 'renders the belongs_to form' do
        textarea = page.at_css('textarea.form-control')
        expect(textarea['name']).to eq "#{resources_name}[#{field_name}]"
        expect(textarea.content).to eq "\nnull"
      end
    end
  end
end
