# frozen_string_literal: true

require 'rails_helper'

partial_name = 'show/date'
describe partial_name, type: :view do
  let(:partial)   { "wallaby/resources/#{partial_name}" }
  let(:value)     { Date.new(2014, 2, 11) }
  let(:metadata)  { {} }

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the date' do
    expect(rendered).to include '2014-02-11'
  end

  context 'when value is a string' do
    let(:value) { 'Tue, 11 Feb 2014 23:59:59 +0000' }

    it 'renders the date' do
      expect(rendered).to include '2014-02-11'
    end
  end

  context 'when value is a time' do
    let(:value) { Time.zone.parse 'Tue, 11 Feb 2014 23:59:59 +0000' }

    it 'renders the date' do
      expect(rendered).to include '2014-02-11'
    end
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
