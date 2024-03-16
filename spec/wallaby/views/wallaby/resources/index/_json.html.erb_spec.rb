# frozen_string_literal: true

require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name, type: :helper do
  it_behaves_like \
    "#{type} partial", field_name,
    value: { 'kind' => 'user_renamed', 'change' => %w[jack john] }.to_json,
    skip_general: true do
    it 'renders the json' do
      expect(page.at_css('code').inner_html).to eq '{"kind":"user_ren...'
      expect(page.at_css('.modaler__title').inner_html).to eq escape(metadata[:label])
      expect(page.at_css('.modaler__body').inner_html).to eq "<pre>#{escape(value)}</pre>"
    end

    context 'when value is less than 20 characters' do
      let(:value) { { 'a' => 1 }.to_json }

      it 'renders the json' do
        expect(rendered).to include h(value)
      end
    end

    context 'when max is set to 50' do
      let(:metadata) { Hash max: 50 }

      it 'renders the json' do
        expect(rendered).to include h(value)
      end
    end
  end
end
