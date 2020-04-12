require 'rails_helper'

partial_name = 'show/belongs_to'
describe partial_name, :wallaby_user do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { Product.new id: 1, name: 'Hiking shoes' }
  let(:metadata)  { Hash class: Product }

  before { render partial, value: value, metadata: metadata }

  it 'renders the belongs_to' do
    expect(rendered).to include view.show_link(value)
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders new_link' do
      expect(rendered).to include view.new_link(metadata[:class])
    end

    context 'when value is polymorphic' do
      let(:metadata) { Hash is_polymorphic: true }

      it 'renders new_link' do
        expect(rendered).to include view.null
      end
    end
  end
end
