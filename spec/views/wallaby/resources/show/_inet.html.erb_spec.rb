# frozen_string_literal: true

require 'rails_helper'

partial_name = 'show/inet'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}" }
  let(:value)     { IPAddr.new '192.168.1.12' }
  let(:metadata)  { {} }

  before do
    render partial, value: value, metadata: metadata
  end

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
