require 'rails_helper'

describe Wallaby::ModelAuthorizer do
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
      expect(described_class.new(Product, :default)).to be_a Wallaby::ModelAuthorizer
    end

    it 'has attributes' do
      subject = described_class.new(Product, :default)
      expect(subject).to respond_to :user
    end
  end
end

class CoreAuthorizer < Wallaby::ModelAuthorizer
  base_class!
end

describe CoreAuthorizer do
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
      expect(described_class.new(Product, :default)).to be_a Wallaby::ModelAuthorizer
    end
  end
end

class ProductAuthorizer < CoreAuthorizer
  self.provider_name = :unknown
end

describe ProductAuthorizer do
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
      expect(described_class.new(Product, :default)).to be_a Wallaby::ModelAuthorizer
    end
  end
end

Object.send(:remove_const, :CoreAuthorizer)
Object.send(:remove_const, :ProductAuthorizer)
