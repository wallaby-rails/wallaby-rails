require 'rails_helper'

partial_name = 'show/uuid'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { '814865cd-5a1d-4771-9306-4268f188fe9e' }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the uuid' do
    expect(rendered).to include "<code>#{value}</code>"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
