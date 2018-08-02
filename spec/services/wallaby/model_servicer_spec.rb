require 'rails_helper'

describe Wallaby::ModelServicer, clear: :object_space do
  describe 'class methods' do
    describe '.model_class' do
      it 'returns nil' do
        expect(described_class.model_class).to be_nil
      end

      describe 'descendants' do
        it 'returns a default model class' do
          stub_const 'JacketServicer', Class.new(Wallaby::ModelServicer)
          stub_const 'Jacket', Class.new
          expect(JacketServicer.model_class).to eq Jacket
        end

        context 'when model class is not found' do
          it 'raises not found' do
            stub_const 'NotFoundServicer', Class.new(Wallaby::ModelServicer)
            expect { NotFoundServicer.model_class }.to raise_error Wallaby::ModelNotFound
          end
        end
      end
    end
  end

  describe 'instance methods' do
    subject { described_class.new model_class: model_class, authorizer: authorizer, model_decorator: model_decorator }
    let(:model_class) { AllPostgresType }
    let(:model_decorator) { Wallaby::ActiveRecord.model_decorator.new model_class }
    let(:provider) { subject.instance_variable_get '@provider' }
    let(:params) { parameters }
    let(:authorizer) { Wallaby::ModelAuthorizer.new nil, model_class }
    let(:resource) { model_class.new }

    it 'has model_class and model_decorator' do
      expect(subject.instance_variable_get('@model_class')).to \
        eq AllPostgresType
    end

    describe '#collection' do
      it 'returns collection' do
        record = AllPostgresType.create
        expect(subject.collection(params)).to contain_exactly record
      end

      it 'deletgates collection method to provider' do
        expect(provider).to receive(:collection).with params, authorizer
        subject.collection params
      end
    end

    describe '#new' do
      it 'returns new object' do
        new_record = subject.new(params)
        expect(new_record).to be_a AllPostgresType
        expect(new_record.persisted?).to be_falsy
      end

      it 'deletgates new method to provider' do
        expect(provider).to receive(:new).with params, authorizer
        subject.new params
      end
    end

    describe '#find' do
      it 'returns the target' do
        record = AllPostgresType.create
        expect(subject.find(record.id, params)).to eq record
      end

      it 'deletgates find method to provider' do
        expect(provider).to receive(:find).with 1, params, authorizer
        subject.find 1, params
      end
    end

    describe '#create' do
      it 'creates a record' do
        params[:all_postgres_type] = { string: 'today' }
        record = subject.new subject.permit(params, :index)
        subject.create record, params
        expect(record).to be_a AllPostgresType
        expect(record.string).to eq 'today'
        expect(record.persisted?).to be_truthy
      end

      it 'deletgates create method to provider' do
        expect(provider).to receive(:create).with resource, params, authorizer
        subject.create resource, params
      end
    end

    describe '#update' do
      it 'updates a record' do
        params[:all_postgres_type] = { string: 'tomorrow' }
        record = AllPostgresType.create string: 'today'
        record = subject.find(record.id, subject.permit(params))
        subject.update record, params
        expect(record.reload.string).to eq 'tomorrow'
      end

      it 'deletgates update method to provider' do
        expect(provider).to receive(:update).with resource, params, authorizer
        subject.update resource, params
      end
    end

    describe '#destroy' do
      it 'removes record' do
        record = AllPostgresType.create
        expect { subject.destroy record, params }.to change { AllPostgresType.count }.from(1).to(0)
      end

      it 'deletgates destroy method to provider' do
        expect(provider).to receive(:destroy).with resource, params, authorizer
        subject.destroy resource, params
      end
    end
  end
end
