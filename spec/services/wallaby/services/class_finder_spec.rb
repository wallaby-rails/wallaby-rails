require 'rails_helper'

describe Wallaby::Services::ClassFinder do
  describe '.all' do
    it 'returns a list of class' do
      expect(described_class.all).to be_kind_of Enumerator
      expect(described_class.all).to all be_kind_of(Class)
    end
  end

  describe '.find' do
    it 'finds the class by given full class name' do
      class TestClass; end
      expect(described_class.find 'testclass').to be_nil
      expect(described_class.find 'TestClass').to eq TestClass
    end
  end
end