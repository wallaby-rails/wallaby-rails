# frozen_string_literal: true

require 'rails_helper'

if Rails::VERSION::MAJOR >= 5
  partial_name = 'show/circle'
  describe partial_name, type: :view do
    let(:partial) { "wallaby/resources/#{partial_name}" }
    let(:value) { resource.circle }
    let(:resource) { AllPostgresType.new circle: '<(1,2),5>' }
    let(:metadata) { { label: 'Circle' } }

    before do
      render partial, value: value, metadata: metadata
    end

    it 'renders the circle' do
      expect(rendered).to include "<code>#{h value}</code>"
    end

    context 'when value is nil' do
      let(:value) { nil }

      it 'renders null' do
        expect(rendered).to include view.null
      end
    end
  end
end
