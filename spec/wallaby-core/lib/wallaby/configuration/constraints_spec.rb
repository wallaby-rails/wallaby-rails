# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Configuration::Constraints do
  describe '#id' do
    it_behaves_like \
      'has attribute with default value',
      :id, described_class::DEFAULT_ID, 'custom_id'

    it 'matches digits' do
      expect(exact(subject.id)).to be_match('1234567890')
    end

    it 'does not match invalid digits' do
      expect(exact(subject.id)).not_to be_match('1234567890xyz')
    end

    it 'matches uuid' do
      expect(exact(subject.id)).to be_match('accd4e99-1bff-4f79-a956-3ea003373ddc')
    end

    it 'does not match invalid uuid' do
      expect(exact(subject.id)).not_to be_match('accd4e99-1bff-6f79-a956-3ea003373ddc')
      expect(exact(subject.id)).not_to be_match('accd4e99-1bff-xxxx-a956-3ea003373ddc')
    end
  end

  describe '#resources' do
    it_behaves_like \
      'has attribute with default value',
      :resources, described_class::DEFAULT_RESOURCES, 'custom_resources'

    it 'matches non-modulized resource name' do
      expect(exact(subject.resources)).to be_match('products')
      expect(exact(subject.resources)).to be_match('products1')
      expect(exact(subject.resources)).to be_match('products12')
    end

    it 'does not match invalid non-modulized resource name' do
      expect(exact(subject.resources)).not_to be_match('1products')
      expect(exact(subject.resources)).not_to be_match('products-')
      expect(exact(subject.resources)).not_to be_match('products_')
      expect(exact(subject.resources)).not_to be_match('products__')
      expect(exact(subject.resources)).not_to be_match('products1-')
      expect(exact(subject.resources)).not_to be_match('products1_')
      expect(exact(subject.resources)).not_to be_match('products1__')
      expect(exact(subject.resources)).not_to be_match('-products')
      expect(exact(subject.resources)).not_to be_match('_products')
    end

    it 'matches modulized resource name' do
      expect(exact(subject.resources)).to be_match('order::items')
      expect(exact(subject.resources)).to be_match('order::items1')
      expect(exact(subject.resources)).to be_match('order/items')
      expect(exact(subject.resources)).to be_match('order/items1')

      expect(exact(subject.resources)).not_to be_match('1order::items')
      expect(exact(subject.resources)).not_to be_match('order::items-')
      expect(exact(subject.resources)).not_to be_match('order::items_')
      expect(exact(subject.resources)).not_to be_match('order::items__')
      expect(exact(subject.resources)).not_to be_match('order::items1-')
      expect(exact(subject.resources)).not_to be_match('order::items1_')
      expect(exact(subject.resources)).not_to be_match('order::items1__')
      expect(exact(subject.resources)).not_to be_match('-order::items')
      expect(exact(subject.resources)).not_to be_match('_order::items')
    end

    it 'does not match invalid modulized resource name' do
      expect(exact(subject.resources)).not_to be_match('1order/items')
      expect(exact(subject.resources)).not_to be_match('order/items-')
      expect(exact(subject.resources)).not_to be_match('order/items_')
      expect(exact(subject.resources)).not_to be_match('order/items__')
      expect(exact(subject.resources)).not_to be_match('order/items1-')
      expect(exact(subject.resources)).not_to be_match('order/items1_')
      expect(exact(subject.resources)).not_to be_match('order/items1__')
      expect(exact(subject.resources)).not_to be_match('-order/items')
      expect(exact(subject.resources)).not_to be_match('_order/items')
    end
  end

  private

  def exact(regex)
    /\A#{regex.source}\Z/x
  end
end
