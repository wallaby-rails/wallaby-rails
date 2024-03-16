# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::AllFields do
  describe '#[] & #[]=' do
    subject { described_class.new(decorator) }

    let(:decorator) { Wallaby::ResourceDecorator.new(Product.new) }

    it 'set the values' do
      expect(decorator.unknown_fields).to be_present

      subject[:name][:type] = 'text'
      expect(decorator.index_fields[:name][:type]).to eq 'text'
      expect(decorator.show_fields[:name][:type]).to eq 'text'
      expect(decorator.form_fields[:name][:type]).to eq 'text'
      expect(decorator.unknown_fields[:name][:type]).to eq 'text'

      subject[:description][:type] = 'markdown'
      expect(decorator.index_fields[:description][:type]).to eq 'markdown'
      expect(decorator.show_fields[:description][:type]).to eq 'markdown'
      expect(decorator.form_fields[:description][:type]).to eq 'markdown'
      expect(decorator.unknown_fields[:description][:type]).to eq 'markdown'
    end
  end
end
