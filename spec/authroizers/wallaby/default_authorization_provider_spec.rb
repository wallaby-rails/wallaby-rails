require 'rails_helper'

describe Wallaby::DefaultAuthorizationProvider do
  describe '.available?' do
    it 'returns true' do
      expect(described_class.available?(nil)).to be_truthy
    end
  end

  describe '.args_from' do
    it 'returns args' do
      expect(described_class.args_from(nil)).to eq({})
      expect(described_class.args_from({})).to eq({})
    end
  end

  describe '.provider_name' do
    it 'returns a string' do
      expect(described_class.provider_name).to eq 'default'
    end
  end

  describe 'instance methods' do
    subject { described_class.new context }
    let(:context) { nil }
    let(:target_class) { Product }
    let(:target) { Product.new }
    let(:scope) { Product.where(nil) }

    describe '#authorize' do
      it 'returns target' do
        expect(subject.authorize(:index, target_class)).to eq target_class
        expect(subject.authorize(:index, target)).to eq target
        expect(subject.authorize(:show, target)).to eq target
        expect(subject.authorize(:new, target)).to eq target
        expect(subject.authorize(:create, target)).to eq target
        expect(subject.authorize(:edit, target)).to eq target
        expect(subject.authorize(:update, target)).to eq target
        expect(subject.authorize(:destroy, target)).to eq target
      end
    end

    describe '#authorized?' do
      it 'returns true' do
        expect(subject.authorized?(:index, target_class)).to be_truthy
        expect(subject.authorized?(:index, target)).to be_truthy
        expect(subject.authorized?(:show, target)).to be_truthy
        expect(subject.authorized?(:new, target)).to be_truthy
        expect(subject.authorized?(:create, target)).to be_truthy
        expect(subject.authorized?(:edit, target)).to be_truthy
        expect(subject.authorized?(:update, target)).to be_truthy
        expect(subject.authorized?(:destroy, target)).to be_truthy
      end
    end

    describe '#accessible_for' do
      it 'returns scope' do
        expect(subject.accessible_for(:index, scope)).to eq scope
        expect(subject.accessible_for(:show, scope)).to eq scope
        expect(subject.accessible_for(:new, scope)).to eq scope
        expect(subject.accessible_for(:create, scope)).to eq scope
        expect(subject.accessible_for(:edit, scope)).to eq scope
        expect(subject.accessible_for(:update, scope)).to eq scope
        expect(subject.accessible_for(:destroy, scope)).to eq scope

        expect(subject.accessible_for(:index, target)).to eq target
        expect(subject.accessible_for(:show, target)).to eq target
        expect(subject.accessible_for(:new, target)).to eq target
        expect(subject.accessible_for(:create, target)).to eq target
        expect(subject.accessible_for(:edit, target)).to eq target
        expect(subject.accessible_for(:update, target)).to eq target
        expect(subject.accessible_for(:destroy, target)).to eq target
      end
    end

    describe '#attributes_for' do
      it 'returns target' do
        expect(subject.attributes_for(:index, target_class)).to eq({})
        expect(subject.attributes_for(:index, target)).to eq({})
        expect(subject.attributes_for(:show, target)).to eq({})
        expect(subject.attributes_for(:new, target)).to eq({})
        expect(subject.attributes_for(:create, target)).to eq({})
        expect(subject.attributes_for(:edit, target)).to eq({})
        expect(subject.attributes_for(:update, target)).to eq({})
        expect(subject.attributes_for(:destroy, target)).to eq({})
      end
    end

    describe '#permit_params' do
      it 'returns nil' do
        expect(subject.permit_params(:index, target_class)).to be_nil
        expect(subject.permit_params(:index, target)).to be_nil
        expect(subject.permit_params(:show, target)).to be_nil
        expect(subject.permit_params(:new, target)).to be_nil
        expect(subject.permit_params(:create, target)).to be_nil
        expect(subject.permit_params(:edit, target)).to be_nil
        expect(subject.permit_params(:update, target)).to be_nil
        expect(subject.permit_params(:destroy, target)).to be_nil
      end
    end
  end
end
