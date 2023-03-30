# frozen_string_literal: true

require 'rails_helper'

partial_name = 'show/cidr'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}" }
  let(:value)     { IPAddr.new '192.168.2.0/24' }
  let(:metadata)  { {} }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the cidr' do
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
