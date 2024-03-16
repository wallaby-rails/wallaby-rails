# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ActiveRecord::CancancanProvider do
  let(:context) { instance_double 'context', current_ability: ability, wallaby_user: user }
  let(:ability) { Ability.new user }
  let(:user) { Staff.new }

  describe '.available?' do
    it 'returns true' do
      expect(described_class).not_to be_available(nil)
      expect(described_class).not_to be_available(double)
      expect(described_class).to be_available(context)
    end
  end

  describe '.provider_name' do
    it 'returns a string' do
      expect(described_class.provider_name).to eq 'cancancan'
    end
  end

  describe 'instance methods' do
    subject { described_class.new options }

    let(:target) { Product.new }
    let(:target_class) { Product }
    let(:scope) { Product.where(nil) }
    let(:options) { { ability: ability } }

    before do
      ability.cannot :index, target_class
      ability.cannot :destroy, target
      ability.can :refresh, target_class, featured: true
    end

    describe '#authorize' do
      it 'returns target' do
        expect { subject.authorize(:index, target_class) }.to raise_error Wallaby::Forbidden
        expect { subject.authorize(:index, target) }.to raise_error Wallaby::Forbidden
        expect(subject.authorize(:show, target)).to eq target
        expect(subject.authorize(:new, target)).to eq target
        expect(subject.authorize(:create, target)).to eq target
        expect(subject.authorize(:edit, target)).to eq target
        expect(subject.authorize(:update, target)).to eq target
        expect { subject.authorize(:destroy, target) }.to raise_error Wallaby::Forbidden
      end
    end

    describe '#authorized?' do
      it 'returns a boolean' do
        expect(subject).not_to be_authorized(:index, target_class)
        expect(subject).not_to be_authorized(:index, target)
        expect(subject).to be_authorized(:show, target)
        expect(subject).to be_authorized(:new, target)
        expect(subject).to be_authorized(:create, target)
        expect(subject).to be_authorized(:edit, target)
        expect(subject).to be_authorized(:update, target)
        expect(subject).not_to be_authorized(:destroy, target)
      end
    end

    describe '#unauthorized?' do
      it 'returns a boolean' do
        expect(subject).to be_unauthorized(:index, target_class)
        expect(subject).to be_unauthorized(:index, target)
        expect(subject).not_to be_unauthorized(:show, target)
        expect(subject).not_to be_unauthorized(:new, target)
        expect(subject).not_to be_unauthorized(:create, target)
        expect(subject).not_to be_unauthorized(:edit, target)
        expect(subject).not_to be_unauthorized(:update, target)
        expect(subject).to be_unauthorized(:destroy, target)
      end
    end

    describe '#accessible_for' do
      it 'returns scope' do
        product = Product.create name: 'Thursday'
        expect(subject.accessible_for(:index, scope)).to eq([])
        expect(subject.accessible_for(:show, scope)).to include product
        expect(subject.accessible_for(:new, scope)).to include product
        expect(subject.accessible_for(:create, scope)).to include product
        expect(subject.accessible_for(:edit, scope)).to include product
        expect(subject.accessible_for(:update, scope)).to include product
        expect(subject.accessible_for(:destroy, scope)).to include product

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
        expect(subject.attributes_for(:refresh, target)).to eq(featured: true)
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
