require 'rails_helper'

describe Wallaby::ActiveRecord::ModelServicer do
  describe 'actions' do
    subject { described_class.new Product }

    describe '#create' do
      it 'returns the resource and is_success' do
        expect_any_instance_of(Product).to receive :save
        resource, is_success = subject.create(sku: 'sku123')
        expect(resource.sku).to eq 'sku123'
        expect(resource.errors).to be_blank
        expect(is_success).to be_truthy
      end
    end

    describe '#update' do
      it 'returns the resource and is_success' do
        product = Product.new
        expect(Product).to receive(:find).and_return product
        expect(product).to receive(:save)
        resource, is_success = subject.update(1, sku: 'sku123')
        expect(resource.sku).to eq 'sku123'
        expect(resource.errors).to be_blank
        expect(is_success).to be_truthy
      end

      context 'when resource is found' do
        it 'returns nil and false' do
          resource, is_success = subject.update(1, sku: 'sku123')
          expect(resource).to be_nil
          expect(is_success).to be_falsy
        end
      end
    end

    describe '#destroy' do
      it 'calls delete' do
        expect(Product).to receive(:delete)
        subject.destroy 1
      end
    end
  end
end
