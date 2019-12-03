require 'rails_helper'

describe Wallaby::ActiveRecord::ModelPaginationProvider do
  describe '#paginatable?' do
    it 'returns true when it uses kaminari' do
      subject = described_class.new Product.page(1), parameters
      expect(subject).to be_paginatable
    end

    it 'returns false when it doesnt use ka' do
      subject = described_class.new Product.where(nil), parameters
      expect(subject).not_to be_paginatable
      subject = described_class.new nil, parameters
      expect(subject).not_to be_paginatable
    end
  end

  describe '#total_count' do
    it 'returns the count' do
      Product.create name: 'product1'
      Product.create name: 'product2'
      Product.create name: 'product3'
      subject = described_class.new Product.page(1), parameters
      expect(subject.total).to eq 3

      subject = described_class.new Product.page(1).per(1), parameters
      expect(subject.total).to eq 3
    end
  end

  describe '#page_size' do
    it 'returns the count' do
      Product.create name: 'product1'
      Product.create name: 'product2'
      Product.create name: 'product3'
      subject = described_class.new Product.page(1), parameters
      expect(subject.page_size).to eq 20

      subject = described_class.new Product.page(1), parameters(per: 1)
      expect(subject.page_size).to eq 1
    end
  end

  describe '#page_number' do
    it 'returns the count' do
      Product.create name: 'product1'
      Product.create name: 'product2'
      Product.create name: 'product3'
      subject = described_class.new Product.page(1), parameters
      expect(subject.page_number).to eq 1

      subject = described_class.new Product.page(1), parameters(page: 2)
      expect(subject.page_number).to eq 2
    end
  end
end
