require 'rails_helper'

describe Wallaby::ActiveRecord::ModelServicer do
  describe 'actions' do
    subject { described_class.new model_class, model_decorator }
    let(:model_class) { AllPostgresType }
    let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new model_class }
    let(:ability) { Ability.new nil }

    describe '#collection' do
      it 'returns the collection' do
        condition = { boolean: true }
        record = model_class.create!(condition)
        false_ability = Ability.new nil
        false_ability.cannot :manage, model_class, condition
        expect(subject.collection parameters({}), ability).to include record
        expect(subject.collection parameters({}), false_ability).not_to include record
      end
    end

    describe '#new' do
      it 'returns a resource' do
        resource = subject.new parameters({})
        expect(resource).to be_a model_class
        expect(resource.attributes.values.compact).to be_blank

        resource = subject.new parameters(string: 'some string')
        expect(resource).to be_a model_class
        expect(resource.attributes.values.compact).to be_blank

        resource = subject.new parameters(all_postgres_type: { string: 'some string' })
        expect(resource).to be_a model_class
        expect(resource.attributes.values.compact).not_to be_blank
        expect(resource.string).to eq 'some string'
      end
    end

    describe '#find' do
      it 'returns a resource' do
        existing = model_class.create!({})
        resource = nil
        expect{ resource = subject.find existing.id, parameters({}) }.not_to raise_error
        expect(resource).to be_a model_class
      end

      context 'when it is not found' do
        it 'raises error' do
          expect{ subject.find 0, parameters({}) }.to raise_error Wallaby::ResourceNotFound
        end
      end
    end

    describe '#create' do
      it 'returns the resource and is_success' do
        resource, is_success = subject.create parameters(all_postgres_type: { string: 'string' }), ability
        expect(resource).to be_a model_class
        expect(resource.id).not_to be_blank
        expect(is_success).to be_truthy
      end

      context 'when params are not valid' do
        it 'returns the resource and is_failed' do
          resource, is_success = subject.create parameters(all_postgres_type: { daterange: [ '', '2016-12-13' ] }), ability
          expect(resource).to be_a model_class
          expect(resource.id).to be_blank
          expect(resource.errors).not_to be_blank
          expect(is_success).to be_falsy
        end
      end

      context 'when database throws error' do
        it 'returns the resource and is_failed' do
          expect_any_instance_of(model_class).to receive(:save) { raise ActiveRecord::StatementInvalid, 'StatementInvalid' }
          resource, is_success = subject.create parameters(all_postgres_type: { string: 'string' }), ability
          expect(resource).to be_a model_class
          expect(resource.id).to be_blank
          expect(resource.errors).not_to be_blank
          expect(resource.errors[:base]).to eq [ 'StatementInvalid' ]
          expect(is_success).to be_falsy
        end
      end
    end

    describe '#update' do
      let!(:existing) { model_class.create! string: 'title' }
      it 'returns the resource and is_success' do
        resource, is_success = subject.update existing, parameters(all_postgres_type: { string: 'string' }), ability
        expect(resource).to be_a model_class
        expect(resource.string).to eq 'string'
        expect(is_success).to be_truthy
      end

      context 'when params are not valid' do
        it 'returns the resource and is_failed' do
          resource, is_success = subject.update existing, parameters(all_postgres_type: { daterange: [ '', '2016-12-13' ] }), ability
          expect(resource).to be_a model_class
          expect(resource.errors).not_to be_blank
          expect(is_success).to be_falsy
        end
      end

      context 'when database throws error' do
        it 'returns the resource and is_failed' do
          expect_any_instance_of(model_class).to receive(:save) { raise ActiveRecord::StatementInvalid, 'StatementInvalid' }
          resource, is_success = subject.update existing, parameters(all_postgres_type: { string: 'string' }), ability
          expect(resource).to be_a model_class
          expect(resource.errors).not_to be_blank
          expect(resource.errors[:base]).to eq [ 'StatementInvalid' ]
          expect(is_success).to be_falsy
        end
      end
    end

    describe '#destroy' do
      it 'returns is_success regardless whether the record exists' do
        existing = model_class.create!({})
        expect(subject.destroy existing, {}).to be_truthy
      end
    end
  end
end
