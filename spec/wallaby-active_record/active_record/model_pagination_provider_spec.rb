# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ActiveRecord::ModelPaginationProvider do
  describe '#paginatable?' do
    it 'returns true when it is a ActiveRecord' do
      subject = described_class.new Product.where(nil), parameters
      expect(subject).to be_paginatable
    end

    it 'returns false when it doesnt use ka' do
      subject = described_class.new [], parameters
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

      query = Product.where(nil)
      subject = described_class.new query, parameters
      expect(subject.total).to eq 3

      query = query.offset(0).limit(1)
      subject = described_class.new query, parameters
      expect(subject.total).to eq 3
    end
  end

  describe '#page_size' do
    it 'returns the count' do
      Product.create name: 'product1'
      Product.create name: 'product2'
      Product.create name: 'product3'
      subject = described_class.new Product.where(nil), parameters
      expect(subject.page_size).to eq 0

      subject = described_class.new Product.where(nil), parameters(per: 1)
      expect(subject.page_size).to eq 1
    end
  end

  describe '#page_number' do
    it 'returns the count' do
      Product.create name: 'product1'
      Product.create name: 'product2'
      Product.create name: 'product3'
      subject = described_class.new Product.where(nil), parameters
      expect(subject.page_number).to eq 1

      subject = described_class.new Product.where(nil), parameters(page: 2)
      expect(subject.page_number).to eq 2
    end
  end
end
