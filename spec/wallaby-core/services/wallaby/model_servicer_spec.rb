# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ModelServicer do
  describe 'instance methods' do
    subject { described_class.new model_class, authorizer, model_decorator }

    let(:model_class) { AllPostgresType }
    let(:model_decorator) { Wallaby::ActiveRecord.model_decorator.new model_class }
    let(:params) { parameters }
    let(:authorizer) { Wallaby::ModelAuthorizer.new model_class, provider_name: :default }
    let(:resource) { model_class.new }

    it 'has model_class and model_decorator' do
      expect(subject.model_class).to eq model_class
    end

    describe '#collection' do
      it 'returns a list of records' do
        record = AllPostgresType.create
        expect(subject.collection(params)).to contain_exactly record
      end
    end

    describe '#new' do
      it 'returns new object' do
        new_record = subject.new(params)
        expect(new_record).to be_a AllPostgresType
        expect(new_record).not_to be_persisted
      end
    end

    describe '#find' do
      it 'returns the target' do
        record = AllPostgresType.create
        expect(subject.find(record.id, params)).to eq record
      end
    end

    describe '#create' do
      it 'creates a record' do
        params[:all_postgres_type] = { string: 'today' }
        record = subject.new params
        subject.create record, subject.permit(params)
        expect(record).to be_a AllPostgresType
        expect(record.string).to eq 'today'
        expect(record).to be_persisted
      end
    end

    describe '#update' do
      it 'updates a record' do
        params[:all_postgres_type] = { string: 'tomorrow' }
        record = AllPostgresType.create string: 'today'
        record = subject.find record.id, params
        subject.update record, subject.permit(params)
        expect(record.reload.string).to eq 'tomorrow'
      end
    end

    describe '#destroy' do
      it 'removes record' do
        record = AllPostgresType.create
        expect { subject.destroy record, params }.to change { AllPostgresType.count }.from(1).to(0)
      end
    end
  end
end
