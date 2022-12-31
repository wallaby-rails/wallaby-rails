# frozen_string_literal: true
require 'rails_helper'

partial_name = 'show/hstore'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     do
    {
      'key' => 'very long long text'
    }
  end

  let(:metadata) { {} }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the hstore' do
    expect(rendered).to include "<pre>#{h value}</pre>"
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
