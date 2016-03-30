require 'rails_helper'

describe Wallaby::ActiveRecord::ModelServicer do
  describe 'actions' do
    subject { described_class.new model_class, model_decorator }
    let(:model_class) { AllPostgresType }
    let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new model_class }

    describe '#collection' do
      it 'returns the collection' do
        expect(model_decorator).to receive(:collection) { [] }
        subject.collection({})
      end
    end

    describe '#new' do
      it 'returns a resource' do
        resource = subject.new ActionController::Parameters.new({})
        expect(resource).to be_a model_class
        expect(resource.attributes.values.compact).to be_blank

        resource = subject.new ActionController::Parameters.new(string: 'some string')
        expect(resource).to be_a model_class
        expect(resource.attributes.values.compact).to be_blank

        resource = subject.new ActionController::Parameters.new(all_postgres_type: { string: 'some string' })
        expect(resource).to be_a model_class
        expect(resource.attributes.values.compact).not_to be_blank
        expect(resource.string).to eq 'some string'
      end
    end

    describe '#find' do
      it 'returns a resource' do
        existing = model_class.create({})
        resource = nil
        expect{ resource = subject.find existing.id, ActionController::Parameters.new({}) }.not_to raise_error
        expect(resource).to be_a model_class
      end

      context 'when it is not found' do
        it 'raises error' do
          expect{ subject.find 0, ActionController::Parameters.new({}) }.to raise_error Wallaby::ResourceNotFound
        end
      end
    end

    describe '#create' do
      it 'returns the resource and is_success' do
        resource, is_success = subject.create ActionController::Parameters.new(all_postgres_type: { string: 'string' })
        expect(resource).to be_a model_class
        expect(resource.id).not_to be_blank
        expect(is_success).to be_truthy
      end

      context 'when params are not valid' do
        it 'returns the resource and is_failed' do
          resource, is_success = subject.create ActionController::Parameters.new(all_postgres_type: { daterange: [ '', '2016-12-13' ] })
          expect(resource).to be_a model_class
          expect(resource.id).to be_blank
          expect(resource.errors).not_to be_blank
          expect(is_success).to be_falsy
        end
      end

      context 'when database throws error' do
        it 'returns the resource and is_failed' do
          expect_any_instance_of(model_class).to receive(:save) { raise ActiveRecord::StatementInvalid, 'StatementInvalid' }
          resource, is_success = subject.create ActionController::Parameters.new(all_postgres_type: { string: 'string' })
          expect(resource).to be_a model_class
          expect(resource.id).to be_blank
          expect(resource.errors).not_to be_blank
          expect(resource.errors[:base]).to eq [ 'StatementInvalid' ]
          expect(is_success).to be_falsy
        end
      end
    end

    describe '#update' do
      let!(:existing) { model_class.create string: 'title' }
      it 'returns the resource and is_success' do
        resource, is_success = subject.update existing.id, ActionController::Parameters.new(all_postgres_type: { string: 'string' })
        expect(resource).to be_a model_class
        expect(resource.string).to eq 'string'
        expect(is_success).to be_truthy
      end

      context 'when resource not found' do
        it 'raises Wallaby::ResourceNotFound' do
          expect{ subject.update 0, ActionController::Parameters.new(all_postgres_type: { daterange: [ '', '2016-12-13' ] }) }.to raise_error Wallaby::ResourceNotFound
        end
      end

      context 'when params are not valid' do
        it 'returns the resource and is_failed' do
          resource, is_success = subject.update existing.id, ActionController::Parameters.new(all_postgres_type: { daterange: [ '', '2016-12-13' ] })
          expect(resource).to be_a model_class
          expect(resource.errors).not_to be_blank
          expect(is_success).to be_falsy
        end
      end

      context 'when database throws error' do
        it 'returns the resource and is_failed' do
          expect_any_instance_of(model_class).to receive(:save) { raise ActiveRecord::StatementInvalid, 'StatementInvalid' }
          resource, is_success = subject.update existing.id, ActionController::Parameters.new(all_postgres_type: { string: 'string' })
          expect(resource).to be_a model_class
          expect(resource.errors).not_to be_blank
          expect(resource.errors[:base]).to eq [ 'StatementInvalid' ]
          expect(is_success).to be_falsy
        end
      end
    end

    describe '#destroy' do
      it 'returns is_success regardless whether the record exists' do
        expect(subject.destroy 0, {}).to be_truthy
        existing = model_class.create({})
        expect(subject.destroy existing.id, {}).to be_truthy
      end
    end
  end
end
