# frozen_string_literal: true

require 'rails_helper'

if Rails::VERSION::MAJOR >= 5
  partial_name = 'show/line'
  describe partial_name do
    let(:partial) { "wallaby/resources/#{partial_name}" }
    let(:value) { resource.line }
    let(:resource) { AllPostgresType.new line: '{1,2,5}' }
    let(:metadata) { { label: 'Line' } }

    before do
      render partial, value: value, metadata: metadata
    end

    it 'renders the line' do
      expect(rendered).to include "<code>#{value}</code>"
    end

    context 'when value is nil' do
      let(:value) { nil }

      it 'renders null' do
        expect(rendered).to include view.null
      end
    end
  end
end
