# frozen_string_literal: true

require 'rails_helper'

partial_name = 'show/sti'
describe partial_name, type: :view do
  let(:partial)   { "wallaby/resources/#{partial_name}" }
  let(:value)     { 'Wallaby::ActiveRecord::ExampleClass' }
  let(:metadata)  { {} }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the sti' do
    expect(rendered).to include value
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
