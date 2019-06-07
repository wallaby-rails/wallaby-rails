require 'rails_helper'

describe Wallaby::ActiveRecord::ModelServiceProvider do
  describe 'actions' do
    subject { described_class.new model_class, model_decorator }
    let(:model_class) { AllPostgresType }
    let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new model_class }
    let(:ability) { Ability.new nil }
    let(:authorizer) { Wallaby::ModelAuthorizer.new model_class, :cancancan, ability: ability }

    describe '#permit' do
      it 'returns the permitted params' do
        expect(subject.permit(parameters(all_postgres_type: { string: 'some string' }), :index, authorizer)).to eq parameters!(string: 'some string')
      end

      it 'raises ActionController::ParameterMissing if parameters is missing' do
        expect { subject.permit(parameters, :index, authorizer) }.to raise_error ActionController::ParameterMissing
        expect { subject.permit(parameters(all_postgres_type: {}), :index, authorizer) }.to raise_error ActionController::ParameterMissing
      end
    end

    describe '#collection' do
      it 'returns the collection' do
        condition = { boolean: true }
        record = model_class.create!(condition)
        expect(subject.collection(parameters, authorizer)).to contain_exactly record
      end

      it 'orders the collection' do
        order = 'integer desc,boolean asc'
        expect(subject.collection(parameters(sort: order), authorizer).to_sql).to match order
      end

      it 'filters the collection' do
        model_decorator.filters[:bingo] = { scope: -> { where integer: 888 } }
        expect(subject.collection(parameters(filter: 'bingo'), authorizer).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" = 888'
      end

      context 'when ability restricts' do
        it 'returns what user has access to' do
          condition = { boolean: true }
          ability.cannot :manage, model_class, condition
          record = model_class.create!(condition)
          expect(subject.collection(parameters, authorizer)).not_to include record
        end
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
        expect(resource.string).to be_nil
        expect(resource.attributes.values.compact).to be_blank
      end
    end

    describe '#find' do
      it 'returns a resource' do
        existing = model_class.create!({})
        resource = subject.find existing.id, parameters, authorizer
        expect(resource).to be_a model_class

        resource = subject.find existing.id, parameters!(string: 'some string'), authorizer
        expect(resource).to be_a model_class
        expect(resource.string).to be_nil
        expect(resource.string).not_to eq 'some string'
      end

      context 'when it is not found' do
        it 'raises error' do
          expect { subject.find 0, parameters, authorizer }.to raise_error Wallaby::ResourceNotFound
        end
      end
    end

    describe '#create' do
      it 'returns the resource' do
        resource = model_class.new
        resource = subject.create resource, parameters!(string: 'some string'), authorizer
        expect(resource).to be_a model_class
        expect(resource.id).not_to be_blank
        expect(resource.errors).to be_blank
      end

      context 'when params are not filtered' do
        it 'returns the resource and its errors' do
          resource = model_class.new
          resource = subject.create resource, parameters(string: 'else'), authorizer
          expect(resource).to be_a model_class
          expect(resource.id).to be_blank
          expect(resource.errors[:base]).to include 'ActiveModel::ForbiddenAttributesError'
        end
      end

      context 'when params are unknown' do
        it 'returns the resource and its errors' do
          resource = subject.new parameters, authorizer
          expect(resource.daterange).to be_blank
          resource = subject.create resource, parameters!(something: 'else'), authorizer
          expect(resource).to be_a model_class
          expect(resource.id).to be_blank
          expect(resource.errors[:base]).to include "unknown attribute 'something' for AllPostgresType."
        end
      end
    end

    describe '#update' do
      let!(:existing) { model_class.create! string: 'title' }

      it 'returns the resource' do
        resource = subject.update existing, parameters!(string: 'string'), authorizer
        expect(resource).to be_a model_class
        expect(resource.string).to eq 'string'
        expect(resource.errors).to be_blank
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
