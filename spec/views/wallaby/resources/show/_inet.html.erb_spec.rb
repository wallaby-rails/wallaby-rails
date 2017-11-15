require 'rails_helper'

partial_name = 'show/inet'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { IPAddr.new '192.168.1.12' }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the inet' do
    expect(rendered).to include "<code>#{value}</code>"
    expect(rendered).to include "http://ip-api.com/##{value}"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
