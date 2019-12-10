require 'rails_helper'

if Rails::VERSION::MAJOR >= 5
  partial_name = 'show/box'
  describe partial_name do
    let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
    let(:value) { resource.box }
    let(:resource) { AllPostgresType.new box: '(1,2),(3,4)' }
    let(:metadata) { { label: 'Box' } }

    before { render partial, value: value, metadata: metadata }

    it 'renders the box' do
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
