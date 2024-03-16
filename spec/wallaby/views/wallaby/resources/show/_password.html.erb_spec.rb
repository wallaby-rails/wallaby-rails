# frozen_string_literal: true

require 'rails_helper'

partial_name = 'show/password'
describe partial_name, type: :view do
  let(:partial) { "wallaby/resources/#{partial_name}" }
  let(:value) { resource.password }
  let(:resource) { AllPostgresType.new password: 'password12356' }
  let(:metadata) { { label: 'Password' } }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the password' do
    expect(rendered).to include '<code>********</code>'
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
