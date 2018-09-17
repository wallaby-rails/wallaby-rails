require 'rails_helper'

describe Wallaby::ModelAuthorizer, type: :helper do
  describe '.model_class' do
    it 'returns nil' do
      expect(described_class.model_class).to be_nil
    end
  end

  describe '.provider_name' do
    it 'returns a string' do
      expect(described_class.provider_name).to be_nil
    end
  end

  describe '.new' do
    it 'returns authorizer' do
      expect(described_class.new(helper, Product)).to be_a Wallaby::ModelAuthorizer
    end
  end
end

class CoreAuthorizer < Wallaby::ModelAuthorizer
  abstract!
end

describe CoreAuthorizer, type: :helper do
  describe '.model_class' do
    it 'returns nil' do
      expect(described_class.model_class).to be_nil
    end
  end

  describe '.provider_name' do
    it 'returns a string' do
      expect(described_class.provider_name).to be_nil
    end
  end

  describe '.new' do
    it 'returns authorizer' do
      expect(described_class.new(helper, Product)).to be_a Wallaby::ModelAuthorizer
    end
  end
end

class ProductAuthorizer < CoreAuthorizer
  self.provider_name = :unknown
end

describe ProductAuthorizer, type: :helper do
  describe '.model_class' do
    it 'returns model class' do
      expect(described_class.model_class).to eq Product
    end
  end

  describe '.provider_name' do
    it 'returns a string' do
      expect(described_class.provider_name).to eq :unknown
    end
  end

  describe '.new' do
    it 'raises error' do
      expect(described_class.new(helper, Product)).to be_a Wallaby::ModelAuthorizer
    end
  end
end

Object.send(:remove_const, :CoreAuthorizer)
Object.send(:remove_const, :ProductAuthorizer)
