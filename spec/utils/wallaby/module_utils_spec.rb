require 'rails_helper'

describe Wallaby::ModuleUtils do
  describe '.try_to' do
    it 'returns the message sent to subject' do
      expect(described_class.try_to(Product, :table_name)).to eq 'products'
    end

    context 'when method_id is blank' do
      it 'returns nil' do
        expect(described_class.try_to(Product, '')).to be_nil
      end
    end

    context 'when method_id is unknown' do
      it 'returns nil' do
        expect(described_class.try_to(Product, :unknown_method)).to be_nil
      end
    end
  end

  describe '.anonymous_class?' do
    it 'returns true when class is anonymous' do
      expect(described_class.anonymous_class?(Class.new)).to be_truthy
      klass = Class.new do
        def self.name
          'not_blank'
        end
      end
      expect(described_class.anonymous_class?(klass)).to be_truthy
    end

    context 'when class is not anonymous' do
      it 'returns false' do
        expect(described_class.anonymous_class?(Product)).to be_falsy
      end
    end
  end

  describe '.inheritance_check' do
    it 'does not raise error' do
      expect { described_class.inheritance_check(Wallaby::ResourcesController, Wallaby::SecureController) }.not_to raise_error
    end

    context 'when class is not a child' do
      it 'raises ArgumentError' do
        expect { described_class.inheritance_check(Wallaby::ModelDecorator, Wallaby::ResourceDecorator) }.to raise_error ArgumentError
      end
    end
  end
end
