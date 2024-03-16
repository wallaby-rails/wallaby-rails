# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Guesser do
  describe '.class_for' do
    it 'returns the associated class' do
      stub_const('Special::SupermanDecorator', Class.new)
      expect(described_class.class_for('Core::Special::SupermenController', suffix: 'Decorator')).to eq Special::SupermanDecorator
    end

    context 'when not found' do
      it 'returns nil' do
        expect(described_class.class_for('Core::Special::SupermenController')).to be_nil
      end
    end

    context 'when there are many classes meet the rules' do
      it 'returns the one matches first' do
        stub_const('Superman', Class.new)
        stub_const('Core::Special', Class.new)
        stub_const('Core::Superman', Class.new)
        stub_const('Special::Superman', Class.new)
        stub_const('Core::Special::Supermen', Class.new)

        expect(described_class.class_for('Core::Special::SupermenController')).to eq Special::Superman
      end
    end
  end
end
