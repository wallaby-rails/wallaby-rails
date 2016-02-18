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
    let(:servicer) { double :servicer }
    subject { described_class.new nil, servicer }

    describe '#create' do
      it 'deletgates create method to servicer' do
        expect(servicer).to receive :create
        subject.create Hash.new
      end
    end

    describe '#update' do
      it 'deletgates update method to servicer' do
        expect(servicer).to receive :update
        subject.update 1, Hash.new
      end
    end

    describe '#destroy' do
      it 'deletgates destroy method to servicer' do
        expect(servicer).to receive :destroy
        subject.destroy 1
      end
    end
  end
end
