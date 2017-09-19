require 'rails_helper'

field_name = 'tsvector'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'",
    input_selector: 'textarea',
    skip_general: true,
    skip_nil: true do

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
