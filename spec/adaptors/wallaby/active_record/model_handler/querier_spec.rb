require 'rails_helper'

describe Wallaby::ActiveRecord::ModelHandler::Querier do
  subject { described_class.new model_decorator }
  let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new AllPostgresType }

  describe '#search' do
    it 'returns all' do
      keyword = ''
      expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types"'
    end

    describe 'text search' do
      it 'returns text search' do
        keyword = 'keyword'
        expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" ILIKE '%keyword%')"

        keyword = 'keyword keyword1'
        expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" ILIKE '%keyword%' AND \"all_postgres_types\".\"string\" ILIKE '%keyword1%')"
      end

      context 'when text_fields include text and citext' do
        before do
          model_decorator.index_field_names << 'text'
        end

        it 'returns text search' do
          keyword = 'keyword'
          expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" ILIKE '%keyword%' OR \"all_postgres_types\".\"text\" ILIKE '%keyword%')"

          keyword = 'keyword keyword1'
          expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" ILIKE '%keyword%' AND \"all_postgres_types\".\"string\" ILIKE '%keyword1%' OR \"all_postgres_types\".\"text\" ILIKE '%keyword%' AND \"all_postgres_types\".\"text\" ILIKE '%keyword1%')"
        end
      end
    end

    describe 'field search' do
      it 'returns field search' do
        keyword = 'integer:1'
        expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" = 1'

        keyword = 'date:>2016-04-30'
        expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"date\" > '2016-04-30')"
      end
    end

    describe 'combine search' do
      it 'returns text and field search' do
        keyword = 'keyword integer:1 date:2016-04-30'
        expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" ILIKE '%keyword%' AND \"all_postgres_types\".\"integer\" = 1 AND \"all_postgres_types\".\"date\" = '2016-04-30')"

        keyword = 'keyword1 keyword2 integer:1 date:2016-04-30'
        expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" ILIKE '%keyword1%' AND \"all_postgres_types\".\"string\" ILIKE '%keyword2%' AND \"all_postgres_types\".\"integer\" = 1 AND \"all_postgres_types\".\"date\" = '2016-04-30')"
      end

      context 'when text_fields include text and citext' do
        before do
          model_decorator.index_field_names << 'text'
        end

        it 'returns text and field search' do
          keyword = 'keyword1 keyword2 integer:1 date:2016-04-30'
          expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE ((\"all_postgres_types\".\"string\" ILIKE '%keyword1%' AND \"all_postgres_types\".\"string\" ILIKE '%keyword2%' OR \"all_postgres_types\".\"text\" ILIKE '%keyword1%' AND \"all_postgres_types\".\"text\" ILIKE '%keyword2%') AND \"all_postgres_types\".\"integer\" = 1 AND \"all_postgres_types\".\"date\" = '2016-04-30')"
        end
      end
    end
  end
end
