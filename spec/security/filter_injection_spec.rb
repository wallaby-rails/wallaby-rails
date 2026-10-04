# frozen_string_literal: true

require 'rails_helper'

# Security regression specs for the filter/scope resolution in
# {Wallaby::ActiveRecord::ModelServiceProvider::Querier}.
#
# Covers OWASP A01/A03: `params[:filter]` must never be used as an arbitrary
# model method name. See the audit finding C1.
describe Wallaby::ActiveRecord::ModelServiceProvider::Querier do
  subject { described_class.new model_decorator }

  let(:model_class) { AllPostgresType }
  let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new model_class }

  describe '#search security' do
    context 'when the decorator declares no filters' do
      before do
        model_decorator.filters.clear
      end

      it 'ignores an arbitrary filter and does not call the model method' do
        allow(model_class).to receive(:delete_all).and_call_original

        sql = subject.search(parameters(filter: 'delete_all')).to_sql

        expect(model_class).not_to have_received(:delete_all)
        expect(sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types"'
      end

      it 'ignores a destructive scope name and leaves records intact' do
        model_class.create!(string: 'kept')
        expect { subject.search(parameters(filter: 'destroy_all')) }
          .not_to change { model_class.count }
      end
    end

    context 'when the decorator declares filters' do
      before do
        model_decorator.filters[:boolean] = { scope: -> { where boolean: true } }
      end

      it 'still allows the declared filter' do
        expect(subject.search(parameters(filter: 'boolean')).to_sql).to eq minor(
          { '>=5.2' => 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."boolean" = TRUE' },
          'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."boolean" = \'t\''
        )
      end

      it 'refuses an undeclared, destructive filter' do
        allow(model_class).to receive(:delete_all).and_call_original

        subject.search(parameters(filter: 'delete_all')).to_sql

        expect(model_class).not_to have_received(:delete_all)
      end

      it 'refuses a declared filter whose metadata points at another scope name' do
        # A filter's `:scope` metadata must not turn an arbitrary name into a
        # callable method: only the declared filter name itself may be invoked.
        model_decorator.filters[:sneaky] = { scope: :delete_all }
        allow(model_class).to receive(:delete_all).and_call_original

        subject.search(parameters(filter: 'sneaky')).to_sql

        expect(model_class).not_to have_received(:delete_all)
      end
    end

    context 'with a request that tries SQL injection through sort' do
      it 'neutralises the injected fragment' do
        sql = subject.search(parameters(sort: 'string desc; DROP TABLE all_postgres_types')).to_sql

        expect(sql).not_to include 'DROP'
      end
    end
  end
end
