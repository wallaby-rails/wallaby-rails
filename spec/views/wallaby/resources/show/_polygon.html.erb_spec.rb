# frozen_string_literal: true

require 'rails_helper'

if Rails::VERSION::MAJOR >= 5
  partial_name = 'show/polygon'
  describe partial_name do
    let(:partial) { "wallaby/resources/#{partial_name}" }
    let(:value) { resource.polygon }
    let(:resource) { AllPostgresType.new polygon: '((1,2),(3,4))' }
    let(:metadata) { { label: 'Polygon' } }

    before do
      render partial, value: value, metadata: metadata
    end

    it 'renders the polygon' do
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
