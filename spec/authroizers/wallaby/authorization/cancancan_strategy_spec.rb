require 'rails_helper'

describe Wallaby::Authorization::CancancanStrategy do
  subject { described_class.new context }
  let(:context) { OpenStruct.new current_ability: current_ability }
  let(:current_ability) { Ability.new nil }
  let(:target) { Product.new }
  let(:target_class) { Product }
  let(:scope) { Product.where(nil) }

  before do
    current_ability.cannot :index, target_class
    current_ability.cannot :destroy, target
  end

  describe '.available?' do
    it 'returns true' do
      expect(described_class.available?(nil)).to be_falsy
      expect(described_class.available?(OpenStruct.new)).to be_falsy
      expect(described_class.available?(context)).to be_truthy
    end
  end

  describe '#authorize' do
    it 'returns target' do
      expect { subject.authorize(:index, target_class) }.to raise_error CanCan::AccessDenied
      expect { subject.authorize(:index, target) }.to raise_error CanCan::AccessDenied
      expect(subject.authorize(:show, target)).to eq target
      expect(subject.authorize(:new, target)).to eq target
      expect(subject.authorize(:create, target)).to eq target
      expect(subject.authorize(:edit, target)).to eq target
      expect(subject.authorize(:update, target)).to eq target
      expect { subject.authorize(:destroy, target) }.to raise_error CanCan::AccessDenied
    end
  end

  describe '#authorize?' do
    it 'returns true' do
      expect(subject.authorize?(:index, target_class)).to be_falsy
      expect(subject.authorize?(:index, target)).to be_falsy
      expect(subject.authorize?(:show, target)).to be_truthy
      expect(subject.authorize?(:new, target)).to be_truthy
      expect(subject.authorize?(:create, target)).to be_truthy
      expect(subject.authorize?(:edit, target)).to be_truthy
      expect(subject.authorize?(:update, target)).to be_truthy
      expect(subject.authorize?(:destroy, target)).to be_falsy
    end
  end

  describe '#authorize_field?' do
    it 'returns true' do
      expect(subject.authorize_field?(:index, target_class, :id)).to be_falsy
      expect(subject.authorize_field?(:index, target, :id)).to be_falsy
      expect(subject.authorize_field?(:show, target, :id)).to be_truthy
      expect(subject.authorize_field?(:new, target, :id)).to be_truthy
      expect(subject.authorize_field?(:create, target, :id)).to be_truthy
      expect(subject.authorize_field?(:edit, target, :id)).to be_truthy
      expect(subject.authorize_field?(:update, target, :id)).to be_truthy
      expect(subject.authorize_field?(:destroy, target, :id)).to be_falsy
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
      expect(subject.attributes_for(:index, target_class)).to eq target_class
      expect(subject.attributes_for(:index, target)).to eq target
      expect(subject.attributes_for(:show, target)).to eq target
      expect(subject.attributes_for(:new, target)).to eq target
      expect(subject.attributes_for(:create, target)).to eq target
      expect(subject.attributes_for(:edit, target)).to eq target
      expect(subject.attributes_for(:update, target)).to eq target
      expect(subject.attributes_for(:destroy, target)).to eq target
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
