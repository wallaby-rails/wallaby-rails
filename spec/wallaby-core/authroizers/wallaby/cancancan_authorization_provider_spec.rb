# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::CancancanAuthorizationProvider do
  describe '.available?' do
    it 'returns false' do
      expect(described_class).not_to be_available(nil)
    end
  end

  describe '.options_from' do
    it 'returns options' do
      expect(described_class.options_from(nil)).to eq(user: nil, ability: nil)
    end

    context 'when wallaby_user defined', type: :controller do
      controller(ApplicationController) do
        def wallaby_user
          { email: 'wallaby@wallaby-rails.org.au' }
        end

        def current_ability
          Ability.new(wallaby_user)
        end
      end

      it 'returns options' do
        expect(described_class.options_from(controller)).to match(
          user: { email: 'wallaby@wallaby-rails.org.au' },
          ability: a_kind_of(Ability)
        )
      end
    end
  end

  describe '.provider_name' do
    it 'returns a string' do
      expect(described_class.provider_name).to eq 'cancancan'
    end
  end

  describe 'instance methods' do
    subject { described_class.new options }

    let(:options) { {} }
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

      context 'when access denied' do
        let(:ability) { Ability.new(nil) }
        let(:options) { { ability: ability } }

        before do
          ability.cannot :index, target_class
        end

        it 'raises error' do
          expect { subject.authorize(:index, target_class) }.to raise_error(Wallaby::Forbidden)
        end
      end
    end

    describe '#authorized?' do
      it 'returns true' do
        expect(subject).to be_authorized(:index, target_class)
        expect(subject).to be_authorized(:index, target)
        expect(subject).to be_authorized(:show, target)
        expect(subject).to be_authorized(:new, target)
        expect(subject).to be_authorized(:create, target)
        expect(subject).to be_authorized(:edit, target)
        expect(subject).to be_authorized(:update, target)
        expect(subject).to be_authorized(:destroy, target)
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
