require 'rails_helper'

partial_name = 'index/inet'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { IPAddr.new '192.168.1.12' }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the inet' do
    expect(rendered).to include '<code>192.168.1.12</code>'
    expect(rendered).to include 'http://ip-api.com/#192.168.1.12'
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
