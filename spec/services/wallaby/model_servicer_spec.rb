require 'rails_helper'

describe Wallaby::ModelServicer do
  describe 'class methods' do
    describe '.model_class' do
      it 'returns nil' do
        expect(described_class.model_class).to be_nil
      end

      describe 'subclasses' do
        it 'returns a default model class' do
          class JacketServicer < Wallaby::ModelServicer; end
          class Jacket; end
          expect(JacketServicer.model_class).to eq Jacket
        end

        context 'when model class is not found' do
          it 'raises not found' do
            class NotFoundServicer < Wallaby::ModelServicer; end
            expect{ NotFoundServicer.model_class }.to raise_error Wallaby::ModelNotFound, 'NotFound'
          end
        end
      end
    end
  end

  describe 'instance methods' do
    subject { described_class.new Product }
    let(:servicer) { subject.instance_variable_get '@servicer' }

    describe '#collection' do
      it 'deletgates collection method to servicer' do
        expect(servicer).to receive :collection
        subject.collection ActionController::Parameters.new({})
      end
    end

    describe '#new' do
      it 'deletgates new method to servicer' do
        expect(servicer).to receive :new
        subject.new ActionController::Parameters.new({})
      end
    end

    describe '#find' do
      it 'deletgates find method to servicer' do
        expect(servicer).to receive :find
        subject.find 1, ActionController::Parameters.new({})
      end
    end

    describe '#create' do
      it 'deletgates create method to servicer' do
        expect(servicer).to receive :create
        subject.create ActionController::Parameters.new({})
      end
    end

    describe '#update' do
      it 'deletgates update method to servicer' do
        expect(servicer).to receive :update
        subject.update 1, ActionController::Parameters.new({})
      end
    end

    describe '#destroy' do
      it 'deletgates destroy method to servicer' do
        expect(servicer).to receive :destroy
        subject.destroy 1, ActionController::Parameters.new({})
      end
    end
  end
end
