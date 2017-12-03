require 'rails_helper'

describe Wallaby::ActiveRecord::ModelServiceProvider::Querier do
  subject { described_class.new model_decorator }
  let(:model_class) { AllPostgresType }
  let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new model_class }

  describe '#search' do
    it 'returns all' do
      keyword = ''
      expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types"'
    end

    describe 'filtering' do
      context 'default scope' do
        it 'queries default scope if no filter is specified' do
          model_decorator.filters[:text] = { scope: proc { where text: text } }
          model_decorator.filters[:boolean] = { scope: proc { where boolean: true }, default: true }
          keyword = ''
          if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
            expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."boolean" = TRUE'
          else
            expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."boolean" = \'t\''
          end
        end
      end

      context 'when scope is a block' do
        before do
          model_decorator.filters[:boolean] = { scope: -> { where boolean: true } }
        end

        it 'returns search with given scope' do
          if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
            expect(subject.search(parameters(filter: 'boolean')).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."boolean" = TRUE'
          else
            expect(subject.search(parameters(filter: 'boolean')).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."boolean" = \'t\''
          end
        end
      end

      context 'when scope is not a block' do
        around do |example|
          AllPostgresType.scope :boolean, (-> { where(boolean: false) })
          model_decorator.filters[:boolean] = { scope: :boolean }
          example.run
          AllPostgresType.singleton_class.send :remove_method, :boolean
        end

        it 'returns search with given scope' do
          if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
            expect(subject.search(parameters(filter: 'boolean')).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = FALSE"
          else
            expect(subject.search(parameters(filter: 'boolean')).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = 'f'"
          end
        end
      end

      context 'when scope does not exist' do
        before do
          model_decorator.filters[:unknown] = { scope: :unknown }
        end

        it 'returns unscoped' do
          expect(subject.search(parameters(filter: 'unknown')).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types"'
        end
      end

      context 'when scope is blank' do
        before do
          model_decorator.filters[:unknown] = { label: 'unknown' }
        end

        it 'returns unscoped' do
          expect(subject.search(parameters(filter: 'unknown')).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types"'
        end
      end

      context 'when filter does not exist' do
        it 'returns unscoped' do
          expect(subject.search(parameters(filter: 'boolean')).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types"'
        end
      end
    end

    describe 'text search' do
      it 'returns text search' do
        keyword = 'keyword'
        expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (((\"all_postgres_types\".\"color\" ILIKE '%keyword%' OR \"all_postgres_types\".\"email\" ILIKE '%keyword%') OR \"all_postgres_types\".\"password\" ILIKE '%keyword%') OR \"all_postgres_types\".\"string\" ILIKE '%keyword%')"

        keyword = 'keyword keyword1'
        expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (((\"all_postgres_types\".\"color\" ILIKE '%keyword%' AND \"all_postgres_types\".\"color\" ILIKE '%keyword1%' OR \"all_postgres_types\".\"email\" ILIKE '%keyword%' AND \"all_postgres_types\".\"email\" ILIKE '%keyword1%') OR \"all_postgres_types\".\"password\" ILIKE '%keyword%' AND \"all_postgres_types\".\"password\" ILIKE '%keyword1%') OR \"all_postgres_types\".\"string\" ILIKE '%keyword%' AND \"all_postgres_types\".\"string\" ILIKE '%keyword1%')"
      end

      context 'when text_fields include text and citext' do
        before do
          model_decorator.index_field_names << 'text'
        end

        it 'returns text search' do
          keyword = 'keyword'
          expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE ((((\"all_postgres_types\".\"color\" ILIKE '%keyword%' OR \"all_postgres_types\".\"email\" ILIKE '%keyword%') OR \"all_postgres_types\".\"password\" ILIKE '%keyword%') OR \"all_postgres_types\".\"string\" ILIKE '%keyword%') OR \"all_postgres_types\".\"text\" ILIKE '%keyword%')"

          keyword = 'keyword keyword1'
          expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE ((((\"all_postgres_types\".\"color\" ILIKE '%keyword%' AND \"all_postgres_types\".\"color\" ILIKE '%keyword1%' OR \"all_postgres_types\".\"email\" ILIKE '%keyword%' AND \"all_postgres_types\".\"email\" ILIKE '%keyword1%') OR \"all_postgres_types\".\"password\" ILIKE '%keyword%' AND \"all_postgres_types\".\"password\" ILIKE '%keyword1%') OR \"all_postgres_types\".\"string\" ILIKE '%keyword%' AND \"all_postgres_types\".\"string\" ILIKE '%keyword1%') OR \"all_postgres_types\".\"text\" ILIKE '%keyword%' AND \"all_postgres_types\".\"text\" ILIKE '%keyword1%')"
        end
      end
    end

    describe 'field search' do
      it 'returns field search' do
        keyword = 'integer:1'
        expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" = 1'
      end

      describe 'expressions' do
        context ':, :=' do
          context 'number' do
            it 'returns eq/in query' do
              keyword = 'integer:1'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" = 1'

              keyword = 'integer:=1'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" = 1'

              keyword = 'integer:1,2'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" IN (1, 2)'

              keyword = 'integer:=1,2'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" IN (1, 2)'
            end
          end

          context 'boolean' do
            it 'returns eq/in query' do
              keyword = 'boolean:true'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = 'true'"

              keyword = 'boolean:false'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = 'false'"

              keyword = 'boolean:=true'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = 'true'"

              keyword = 'boolean:=false'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = 'false'"

              keyword = 'boolean:=true,false'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" IN ('true', 'false')"
            end
          end

          context 'string' do
            it 'returns eq/in query' do
              keyword = 'string:name'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" = 'name'"

              keyword = 'string:=name'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" = 'name'"

              keyword = 'string:something,else'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" IN ('something', 'else')"

              keyword = 'string:=something,else'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" IN ('something', 'else')"
            end
          end

          context 'date' do
            it 'returns eq/in query' do
              keyword = 'date:2017-06-30'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" = '2017-06-30'"

              keyword = 'date:=2017-06-30'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" = '2017-06-30'"

              keyword = 'date:2017-06-30,2017-07-01'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" IN ('2017-06-30', '2017-07-01')"

              keyword = 'date:=2017-06-30,2017-07-01'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" IN ('2017-06-30', '2017-07-01')"
            end
          end
        end

        context ':!,:!=,:<>' do
          context 'number' do
            it 'returns not_eq/in query' do
              if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
                keyword = 'integer:!1'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" != 1'

                keyword = 'integer:!=1'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" != 1'

                keyword = 'integer:<>1'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" != 1'

                keyword = 'integer:!1,2'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" NOT IN (1, 2)'

                keyword = 'integer:!=1,2'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" NOT IN (1, 2)'

                keyword = 'integer:<>1,2'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" NOT IN (1, 2)'
              else
                keyword = 'integer:!1'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" != 1)'

                keyword = 'integer:!=1'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" != 1)'

                keyword = 'integer:<>1'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" != 1)'

                keyword = 'integer:!1,2'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" NOT IN (1, 2))'

                keyword = 'integer:!=1,2'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" NOT IN (1, 2))'

                keyword = 'integer:<>1,2'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" NOT IN (1, 2))'
              end
            end
          end

          context 'boolean' do
            it 'returns not_eq/in query' do
              if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
                keyword = 'boolean:!true'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" != 'true'"

                keyword = 'boolean:!false'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" != 'false'"

                keyword = 'boolean:!=true'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" != 'true'"

                keyword = 'boolean:!=false'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" != 'false'"

                keyword = 'boolean:<>true'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" != 'true'"

                keyword = 'boolean:<>false'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" != 'false'"

                keyword = 'boolean:!true,false'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" NOT IN ('true', 'false')"

                keyword = 'boolean:!=true,false'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" NOT IN ('true', 'false')"

                keyword = 'boolean:<>true,false'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" NOT IN ('true', 'false')"
              else
                keyword = 'boolean:!true'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" != 'true')"

                keyword = 'boolean:!false'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" != 'false')"

                keyword = 'boolean:!=true'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" != 'true')"

                keyword = 'boolean:!=false'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" != 'false')"

                keyword = 'boolean:<>true'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" != 'true')"

                keyword = 'boolean:<>false'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" != 'false')"

                keyword = 'boolean:!true,false'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" NOT IN ('true', 'false'))"

                keyword = 'boolean:!=true,false'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" NOT IN ('true', 'false'))"

                keyword = 'boolean:<>true,false'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" NOT IN ('true', 'false'))"
              end
            end
          end

          context 'string' do
            it 'returns not_eq/in query' do
              if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
                keyword = 'string:!name'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" != 'name'"

                keyword = 'string:!=name'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" != 'name'"

                keyword = 'string:<>name'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" != 'name'"

                keyword = 'string:!something,else'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" NOT IN ('something', 'else')"

                keyword = 'string:!=something,else'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" NOT IN ('something', 'else')"

                keyword = 'string:<>something,else'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" NOT IN ('something', 'else')"
              else
                keyword = 'string:!name'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" != 'name')"

                keyword = 'string:!=name'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" != 'name')"

                keyword = 'string:<>name'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" != 'name')"

                keyword = 'string:!something,else'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" NOT IN ('something', 'else'))"

                keyword = 'string:!=something,else'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" NOT IN ('something', 'else'))"

                keyword = 'string:<>something,else'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" NOT IN ('something', 'else'))"
              end
            end
          end

          context 'date' do
            it 'returns not_eq/in query' do
              if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
                keyword = 'date:!2017-06-30'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" != '2017-06-30'"

                keyword = 'date:!=2017-06-30'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" != '2017-06-30'"

                keyword = 'date:<>2017-06-30'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" != '2017-06-30'"

                keyword = 'date:!2017-06-30,2017-07-01'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" NOT IN ('2017-06-30', '2017-07-01')"

                keyword = 'date:!=2017-06-30,2017-07-01'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" NOT IN ('2017-06-30', '2017-07-01')"

                keyword = 'date:<>2017-06-30,2017-07-01'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" NOT IN ('2017-06-30', '2017-07-01')"
              else
                keyword = 'date:!2017-06-30'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"date\" != '2017-06-30')"

                keyword = 'date:!=2017-06-30'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"date\" != '2017-06-30')"

                keyword = 'date:<>2017-06-30'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"date\" != '2017-06-30')"

                keyword = 'date:!2017-06-30,2017-07-01'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"date\" NOT IN ('2017-06-30', '2017-07-01'))"

                keyword = 'date:!=2017-06-30,2017-07-01'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"date\" NOT IN ('2017-06-30', '2017-07-01'))"

                keyword = 'date:<>2017-06-30,2017-07-01'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"date\" NOT IN ('2017-06-30', '2017-07-01'))"
              end
            end
          end
        end

        context ':~' do
          it 'returns the matcing query' do
            if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
              keyword = 'string:~something'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" ILIKE '%something%'"
            else
              keyword = 'string:~something'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" ILIKE '%something%')"
            end
          end
        end

        context ':^' do
          it 'returns the matcing query' do
            if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
              keyword = 'string:^starting'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" ILIKE 'starting%'"
            else
              keyword = 'string:^starting'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" ILIKE 'starting%')"
            end
          end
        end

        context ':$' do
          it 'returns the matcing query' do
            if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
              keyword = 'string:$ending'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" ILIKE '%ending'"
            else
              keyword = 'string:$ending'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" ILIKE '%ending')"
            end
          end
        end

        context ':!~' do
          it 'returns the matcing query' do
            if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
              keyword = 'string:!~something'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" NOT ILIKE '%something%'"
            else
              keyword = 'string:!~something'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" NOT ILIKE '%something%')"
            end
          end
        end

        context ':!^' do
          it 'returns the matcing query' do
            if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
              keyword = 'string:!^starting'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" NOT ILIKE 'starting%'"
            else
              keyword = 'string:!^starting'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" NOT ILIKE 'starting%')"
            end
          end
        end

        context ':!$' do
          it 'returns the matcing query' do
            if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
              keyword = 'string:!$ending'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" NOT ILIKE '%ending'"
            else
              keyword = 'string:!$ending'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" NOT ILIKE '%ending')"
            end
          end
        end

        context ':>' do
          it 'returns the comparing query' do
            if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
              keyword = 'integer:>100'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" > 100'
            else
              keyword = 'integer:>100'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" > 100)'
            end
          end
        end

        context ':>=' do
          it 'returns the comparing query' do
            if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
              keyword = 'integer:>=100'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" >= 100'
            else
              keyword = 'integer:>=100'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" >= 100)'
            end
          end
        end

        context ':<' do
          it 'returns the comparing query' do
            if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
              keyword = 'integer:<100'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" < 100'
            else
              keyword = 'integer:<100'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" < 100)'
            end
          end
        end

        context ':<=' do
          it 'returns the comparing query' do
            if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
              keyword = 'integer:<=100'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" <= 100'
            else
              keyword = 'integer:<=100'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" <= 100)'
            end
          end
        end

        context ':()' do
          it 'returns the comparing query' do
            if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
              keyword = 'integer:()100,999'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" BETWEEN 100 AND 999'
            else
              keyword = 'integer:()100,999'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" BETWEEN 100 AND 999)'
            end
          end
        end

        context ':!()' do
          it 'returns the comparing query' do
            keyword = 'integer:!()100,999'
            expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" < 100 OR "all_postgres_types"."integer" > 999)'
          end
        end
      end

      context 'when field does not exist' do
        it 'returns unscoped' do
          keyword = 'unknown:something'
          expect(subject.search(parameters(q: keyword)).to_sql).to eq 'SELECT "all_postgres_types".* FROM "all_postgres_types"'
        end
      end
    end

    describe 'complex search' do
      before do
        model_decorator.filters[:boolean] = { scope: -> { where boolean: true } }
      end

      it 'returns search result' do
        keyword = 'keyword integer:!=1 date:>2016-04-30'
        if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
          expect(subject.search(parameters(filter: 'boolean', q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = TRUE AND (((\"all_postgres_types\".\"color\" ILIKE '%keyword%' OR \"all_postgres_types\".\"email\" ILIKE '%keyword%') OR \"all_postgres_types\".\"password\" ILIKE '%keyword%') OR \"all_postgres_types\".\"string\" ILIKE '%keyword%') AND \"all_postgres_types\".\"integer\" != 1 AND \"all_postgres_types\".\"date\" > '2016-04-30'"
        else
          expect(subject.search(parameters(filter: 'boolean', q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = 't' AND ((((\"all_postgres_types\".\"color\" ILIKE '%keyword%' OR \"all_postgres_types\".\"email\" ILIKE '%keyword%') OR \"all_postgres_types\".\"password\" ILIKE '%keyword%') OR \"all_postgres_types\".\"string\" ILIKE '%keyword%') AND \"all_postgres_types\".\"integer\" != 1 AND \"all_postgres_types\".\"date\" > '2016-04-30')"
        end
      end
    end
  end
end
