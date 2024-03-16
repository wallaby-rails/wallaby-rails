# frozen_string_literal: true

require 'rails_helper'

partial_name = 'show/datetime'
describe partial_name, type: :view do
  let(:partial)   { "wallaby/resources/#{partial_name}" }
  let(:value)     { Time.new(2014, 2, 11, 23, 59, 59, '+00:00') }
  let(:metadata)  { {} }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the datetime' do
    expect(rendered).to include 'Tue, 11 Feb 2014 23:59:59 +0000'
  end

  context 'when value is a string' do
    let(:value) { 'Tue, 11 Feb 2014 23:59:59 +0000' }

    it 'renders the datetime' do
      expect(rendered).to include 'Tue, 11 Feb 2014 23:59:59 +0000'
    end
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
