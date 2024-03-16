# frozen_string_literal: true

require 'rails_helper'

if Rails::VERSION::MAJOR >= 5
  partial_name = 'show/path'
  describe partial_name, type: :view do
    let(:partial) { "wallaby/resources/#{partial_name}" }
    let(:value) { resource.path }
    let(:resource) { AllPostgresType.new path: '((1,2),(3,4))' }
    let(:metadata) { { label: 'Path' } }

    before do
      render partial, value: value, metadata: metadata
    end

    it 'renders the path' do
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
