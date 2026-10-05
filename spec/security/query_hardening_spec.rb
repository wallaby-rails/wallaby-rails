# frozen_string_literal: true

require 'rails_helper'

# Security regression specs for query/sort hardening.
#
# Covers OWASP A03 (injection) and A05 (misconfiguration): sort input must not
# reach SQL unvalidated (M4), and oversized queries are rejected (L8).
describe Wallaby::ActiveRecord::ModelServiceProvider::Querier do
  subject { described_class.new model_decorator }

  let(:model_class) { AllPostgresType }
  let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new model_class }

  describe '#sort' do
    it 'orders by a declared index field' do
      sql = subject.sort('string desc', model_class.all).to_sql
      expect(sql).to include 'ORDER BY all_postgres_types.string DESC'
    end

    it 'drops fields that are not plain identifiers' do
      sql = subject.sort('string desc); DROP TABLE all_postgres_types; --', model_class.all).to_sql
      expect(sql).not_to include 'DROP'
    end

    it 'drops unknown fields' do
      expect(subject.sort('unknown_field desc', model_class.all).to_sql)
        .not_to include 'unknown_field'
    end

    it 'rejects an invalid direction' do
      sql = subject.sort('string sideways', model_class.all).to_sql
      expect(sql).not_to include 'sideways'
    end
  end

  describe '#search query length guard' do
    it 'rejects an oversized query string' do
      query = 'a' * (described_class::MAX_QUERY_LENGTH + 1)
      expect { subject.search(parameters(q: query)).to_sql }
        .to raise_error Wallaby::UnprocessableEntity
    end

    it 'accepts a query at the maximum length' do
      query = 'a' * described_class::MAX_QUERY_LENGTH
      expect { subject.search(parameters(q: query)).to_sql }.not_to raise_error
    end
  end
end
