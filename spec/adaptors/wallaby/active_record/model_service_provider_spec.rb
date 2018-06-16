require 'rails_helper'

describe Wallaby::ActiveRecord::ModelServiceProvider do
  describe 'actions' do
    subject { described_class.new model_class, model_decorator }
    let(:model_class) { AllPostgresType }
    let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new model_class }
    let(:ability) { Ability.new nil }
    let(:authorizer) { Wallaby::ModelAuthorizer.new cancancan_context(ability), model_class }

    describe '#permit' do
      it 'returns the permitted params' do
        expect { subject.permit(parameters, :index, authorizer) }.to raise_error ActionController::ParameterMissing
        expect { subject.permit(parameters(all_postgres_type: {}), :index, authorizer) }.to raise_error ActionController::ParameterMissing
        expect(subject.permit(parameters(all_postgres_type: { string: 'some string' }), :index, authorizer)).to eq parameters!(string: 'some string')
      end
    end

    describe '#collection' do
      it 'returns the collection' do
        condition = { boolean: true }
        record = model_class.create!(condition)
        false_ability = Ability.new nil
        false_ability.cannot :manage, model_class, condition
        false_authorizer = Wallaby::ModelAuthorizer.new cancancan_context(false_ability), model_class
        expect(subject.collection(parameters, authorizer)).to include record
        expect(subject.collection(parameters, false_authorizer)).not_to include record
      end

      it 'orders the collection' do
        order = 'boolean asc'
        expect(subject.collection(parameters(sort: order), authorizer).to_sql).to match order
      end
    end

    describe '#paginate' do
      it 'paginates the query' do
        expect(subject.paginate(model_class.where(nil), parameters(page: 10, per: 8)).to_sql).to eq 'SELECT  "all_postgres_types".* FROM "all_postgres_types" LIMIT 8 OFFSET 72'
      end
    end

    describe '#new' do
      it 'returns a resource' do
        resource = subject.new parameters, authorizer
        expect(resource).to be_a model_class
        expect(resource).to be_new_record
        expect(resource.attributes.values.compact).to be_blank

        resource = subject.new parameters!(string: 'some string'), authorizer
        expect(resource).to be_a model_class
        expect(resource).to be_new_record
        expect(resource.attributes.values.compact).not_to be_blank
        expect(resource.string).to eq 'some string'
      end

      context 'when unknown attribute' do
        it 'returns a blank resource' do
          resource = subject.new parameters!(unknown_attribute: 'unknown'), authorizer
          expect(resource).to be_a model_class
          expect(resource.attributes.values.compact).to be_blank
        end
      end
    end

    describe '#find' do
      it 'returns a resource' do
        existing = model_class.create!({})
        resource = subject.find existing.id, parameters, authorizer
        expect(resource).to be_a model_class

        resource = subject.find existing.id, parameters!(string: 'some string'), authorizer
        expect(resource).to be_a model_class
        expect(resource.string).to eq 'some string'
      end

      context 'when it is not found' do
        it 'raises error' do
          expect { subject.find 0, parameters, authorizer }.to raise_error Wallaby::ResourceNotFound
        end
      end

      context 'when unknown attribute' do
        it 'returns a blank resource' do
          existing = model_class.create!(string: 'some string')
          resource = subject.find existing.id, parameters!(unknown_attribute: 'unknown'), authorizer
          expect(resource).to be_a model_class
          expect(resource).to eq existing
        end
      end
    end

    describe '#create' do
      it 'returns the resource' do
        resource = subject.new parameters!(string: 'some string'), authorizer
        resource = subject.create resource, parameters(all_postgres_type: { string: 'some string' }), authorizer
        expect(resource).to be_a model_class
        expect(resource.id).not_to be_blank
        expect(resource.errors).to be_blank
      end

      context 'when params are not valid' do
        it 'returns the resource and its errors' do
          resource = subject.new parameters!(daterange: ['', '2016-12-13']), authorizer
          resource = subject.create resource, parameters(all_postgres_type: { daterange: ['', '2016-12-13'] }), authorizer
          expect(resource).to be_a model_class
          expect(resource.id).to be_blank
          expect(resource.errors).not_to be_blank
        end
      end

      context 'when database throws error' do
        it 'returns the resource and its errors' do
          resource = subject.new parameters!(string: 'some string'), authorizer
          expect(resource).to receive(:save) { raise ActiveRecord::StatementInvalid, 'StatementInvalid' }
          resource = subject.create resource, parameters(all_postgres_type: { string: 'string' }), authorizer
          expect(resource).to be_a model_class
          expect(resource.id).to be_blank
          expect(resource.errors).not_to be_blank
          expect(resource.errors[:base]).to eq ['StatementInvalid']
        end
      end
    end

    describe '#update' do
      let!(:existing) { model_class.create! string: 'title' }
      it 'returns the resource' do
        existing.string = 'string'
        resource = subject.update existing, parameters(all_postgres_type: { string: 'string' }), authorizer
        expect(resource).to be_a model_class
        expect(resource.string).to eq 'string'
        expect(resource.errors).to be_blank
      end

      context 'when database throws error' do
        it 'returns the resource and its errors' do
          existing.string = 'string'
          expect(existing).to receive(:save) { raise ActiveRecord::StatementInvalid, 'StatementInvalid' }
          resource = subject.update existing, parameters(all_postgres_type: { string: 'string' }), authorizer
          expect(resource).to be_a model_class
          expect(resource.errors).not_to be_blank
          expect(resource.errors[:base]).to eq ['StatementInvalid']
        end
      end
    end

    describe '#destroy' do
      it 'returns is_success regardless whether the record exists' do
        existing = model_class.create!({})
        expect(subject.destroy(existing, {}, authorizer)).to be_truthy
      end
    end
  end
end
