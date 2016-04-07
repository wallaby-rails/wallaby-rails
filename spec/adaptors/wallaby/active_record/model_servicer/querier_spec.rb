require 'rails_helper'

describe Wallaby::ActiveRecord::ModelServicer::Querier do
  subject { described_class.new model_decorator }
  let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new AllPostgresType }

  describe '#search' do
    it 'returns all' do
      keyword = ''
      expect(subject.search(parameters({ q: keyword })).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\""
    end

    describe 'text search' do
      it 'returns text search' do
        keyword = 'keyword'
        expect(subject.search(parameters({ q: keyword })).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE ((UPPER(string) LIKE '%KEYWORD%'))"

        keyword = 'keyword keyword1'
        expect(subject.search(parameters({ q: keyword })).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE ((UPPER(string) LIKE '%KEYWORD%' AND UPPER(string) LIKE '%KEYWORD1%'))"
      end

      context 'when text_fields include text and citext' do
        before do
          allow(subject).to receive(:text_fields) { %w( string text ) }
        end

        it 'returns text search' do
          keyword = 'keyword'
          expect(subject.search(parameters({ q: keyword })).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE ((UPPER(string) LIKE '%KEYWORD%') OR (UPPER(text) LIKE '%KEYWORD%'))"

          keyword = 'keyword keyword1'
          expect(subject.search(parameters({ q: keyword })).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE ((UPPER(string) LIKE '%KEYWORD%' AND UPPER(string) LIKE '%KEYWORD1%') OR (UPPER(text) LIKE '%KEYWORD%' AND UPPER(text) LIKE '%KEYWORD1%'))"
        end
      end
    end

    describe 'field search' do
      it 'returns field search' do
        keyword = 'integer:1'
        expect(subject.search(parameters({ q: keyword })).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"integer\" = 1"

        keyword = 'date:2016-04-30'
        expect(subject.search(parameters({ q: keyword })).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" = '2016-04-30'"
      end
    end

    describe 'combine search' do
      it 'returns text and field search' do
        keyword = 'keyword integer:1 date:2016-04-30'
        expect(subject.search(parameters({ q: keyword })).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE ((UPPER(string) LIKE '%KEYWORD%')) AND \"all_postgres_types\".\"integer\" = 1 AND \"all_postgres_types\".\"date\" = '2016-04-30'"

        keyword = 'keyword1 keyword2 integer:1 date:2016-04-30'
        expect(subject.search(parameters({ q: keyword })).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE ((UPPER(string) LIKE '%KEYWORD1%' AND UPPER(string) LIKE '%KEYWORD2%')) AND \"all_postgres_types\".\"integer\" = 1 AND \"all_postgres_types\".\"date\" = '2016-04-30'"
      end
    end
  end
end
