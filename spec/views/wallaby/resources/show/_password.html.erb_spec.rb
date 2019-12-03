require 'rails_helper'

partial_name = 'show/password'
describe partial_name do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value) { resource.password }
  let(:resource) { AllPostgresType.new password: 'password12356' }
  let(:metadata) { { label: 'Password' } }

  before { render partial, value: value, metadata: metadata }

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
