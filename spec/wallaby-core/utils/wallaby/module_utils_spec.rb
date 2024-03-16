# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ModuleUtils do
  describe '.anonymous_class?' do
    it 'returns true when class is anonymous' do
      expect(described_class).to be_anonymous_class(Class.new)
      klass = Class.new do
        def self.name
          'not_blank'
        end
      end
      expect(described_class).to be_anonymous_class(klass)
    end

    context 'when class is not anonymous' do
      it 'returns false' do
        expect(described_class).not_to be_anonymous_class(Product)
      end
    end
  end

  describe '.inheritance_check' do
    it 'does not raise error' do
      expect { described_class.inheritance_check(ApplicationController, ActionController::Base) }.not_to raise_error
    end

    context 'when class is not a child' do
      it 'raises ArgumentError' do
        expect { described_class.inheritance_check(Wallaby::ModelDecorator, Wallaby::ResourceDecorator) }.to raise_error ArgumentError
      end
    end
  end
end
