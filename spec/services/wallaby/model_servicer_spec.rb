require 'rails_helper'

describe Wallaby::ModelServicer, clear: :object_space do
  describe 'class methods' do
    describe '.model_class' do
      it 'returns nil' do
        expect(described_class.model_class).to be_nil
      end

      describe 'subclasses' do
        it 'returns a default model class' do
          stub_const 'JacketServicer', Class.new(Wallaby::ModelServicer)
          stub_const 'Jacket', Class.new
          expect(JacketServicer.model_class).to eq Jacket
        end

        context 'when model class is not found' do
          it 'raises not found' do
            stub_const 'NotFoundServicer', Class.new(Wallaby::ModelServicer)
            expect{ NotFoundServicer.model_class }.to raise_error Wallaby::ModelNotFound, 'NotFound from NotFoundServicer'
          end
        end
      end
    end
  end

  describe 'instance methods' do
    subject { described_class.new AllPostgresType }
    let(:delegator)  { subject.instance_variable_get '@delegator' }
    let(:params)    { parameters }
    let(:ability)   { Ability.new nil }
    let(:resource)  { AllPostgresType.new }

    it 'has model_class and model_decorator' do
      expect(subject.instance_variable_get '@model_class').to eq AllPostgresType
      expect(subject.instance_variable_get '@model_decorator').to be_a Wallaby::ModelDecorator
    end

    describe '#collection' do
      it 'deletgates collection method to delegator' do
        expect(delegator).to receive(:collection).with params, ability
        subject.collection params, ability
      end
    end

    describe '#new' do
      it 'deletgates new method to delegator' do
        expect(delegator).to receive(:new).with params
        subject.new params
      end
    end

    describe '#find' do
      it 'deletgates find method to delegator' do
        expect(delegator).to receive(:find).with 1, params
        subject.find 1, params
      end
    end

    describe '#create' do
      it 'deletgates create method to delegator' do
        expect(delegator).to receive(:create).with params, ability
        subject.create params, ability
      end
    end

    describe '#update' do
      it 'deletgates update method to delegator' do
        expect(delegator).to receive(:update).with resource, params, ability
        subject.update resource, params, ability
      end
    end

    describe '#destroy' do
      it 'deletgates destroy method to delegator' do
        expect(delegator).to receive(:destroy).with resource, params
        subject.destroy resource, params
      end
    end
  end
end
