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
          expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
            {
              5 => {
                2 => 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."boolean" = TRUE'
              }
            },
            'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."boolean" = \'t\''
          )
        end
      end

      context 'when scope is a block' do
        before do
          model_decorator.filters[:boolean] = { scope: -> { where boolean: true } }
        end

        it 'returns search with given scope' do
          expect(subject.search(parameters(filter: 'boolean')).to_sql).to eq minor(
            {
              5 => {
                2 => 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."boolean" = TRUE'
              }
            },
            'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."boolean" = \'t\''
          )
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
          expect(subject.search(parameters(filter: 'boolean')).to_sql).to eq minor(
            {
              5 => {
                2 => 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."boolean" = FALSE'
              }
            },
            "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = 'f'"
          )
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

      context 'when no text_fields' do
        before do
          model_decorator.index_field_names.delete 'string'
          model_decorator.index_field_names.delete 'color'
          model_decorator.index_field_names.delete 'email'
          model_decorator.index_field_names.delete 'password'
        end

        it 'raises UnprocessableEntity' do
          keyword = 'keyword'
          expect { subject.search(parameters(q: keyword)).to_sql }.to raise_error Wallaby::UnprocessableEntity
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
              if version? '~> 5.2.1'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = TRUE"
              else
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = 'true'"
              end

              keyword = 'boolean:false'
              if version? '~> 5.2.1'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = FALSE"
              else
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = 'false'"
              end

              keyword = 'boolean:=true'
              if version? '~> 5.2.1'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = TRUE"
              else
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = 'true'"
              end

              keyword = 'boolean:=false'
              if version? '~> 5.2.1'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = FALSE"
              else
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" = 'false'"
              end

              keyword = 'boolean:=true,false'
              if version? '~> 5.2.1'
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" IN (TRUE, FALSE)"
              else
                expect(subject.search(parameters(q: keyword)).to_sql).to eq "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" IN ('true', 'false')"
              end
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
              keyword = 'integer:!1'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" != 1'
                  }
                },
                'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" != 1)'
              )

              keyword = 'integer:!=1'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" != 1'
                  }
                },
                'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" != 1)'
              )

              keyword = 'integer:<>1'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" != 1'
                  }
                },
                'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" != 1)'
              )

              keyword = 'integer:!1,2'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" NOT IN (1, 2)'
                  }
                },
                'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" NOT IN (1, 2))'
              )

              keyword = 'integer:!=1,2'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" NOT IN (1, 2)'
                  }
                },
                'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" NOT IN (1, 2))'
              )

              keyword = 'integer:<>1,2'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" NOT IN (1, 2)'
                  }
                },
                'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" NOT IN (1, 2))'
              )
            end
          end

          context 'boolean' do
            it 'returns not_eq/in query' do
              keyword = 'boolean:!true'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" != TRUE"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" != 'true')"
              )

              keyword = 'boolean:!false'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" != FALSE"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" != 'false')"
              )

              keyword = 'boolean:!=true'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" != TRUE"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" != 'true')"
              )

              keyword = 'boolean:!=false'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" != FALSE"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" != 'false')"
              )

              keyword = 'boolean:<>true'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" != TRUE"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" != 'true')"
              )

              keyword = 'boolean:<>false'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" != FALSE"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" != 'false')"
              )

              keyword = 'boolean:!true,false'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" NOT IN (TRUE, FALSE)"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" NOT IN ('true', 'false'))"
              )

              keyword = 'boolean:!=true,false'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" NOT IN (TRUE, FALSE)"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" NOT IN ('true', 'false'))"
              )

              keyword = 'boolean:<>true,false'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"boolean\" NOT IN (TRUE, FALSE)"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"boolean\" NOT IN ('true', 'false'))"
              )
            end
          end

          context 'string' do
            it 'returns not_eq/in query' do
              keyword = 'string:!name'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" != 'name'"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" != 'name')"
              )

              keyword = 'string:!=name'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" != 'name'"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" != 'name')"
              )

              keyword = 'string:<>name'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" != 'name'"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" != 'name')"
              )

              keyword = 'string:!something,else'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" NOT IN ('something', 'else')"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" NOT IN ('something', 'else'))"
              )

              keyword = 'string:!=something,else'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" NOT IN ('something', 'else')"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" NOT IN ('something', 'else'))"
              )

              keyword = 'string:<>something,else'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" NOT IN ('something', 'else')"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" NOT IN ('something', 'else'))"
              )
            end
          end

          context 'date' do
            it 'returns not_eq/in query' do
              keyword = 'date:!2017-06-30'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" != '2017-06-30'"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"date\" != '2017-06-30')"
              )

              keyword = 'date:!=2017-06-30'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" != '2017-06-30'"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"date\" != '2017-06-30')"
              )

              keyword = 'date:<>2017-06-30'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" != '2017-06-30'"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"date\" != '2017-06-30')"
              )

              keyword = 'date:!2017-06-30,2017-07-01'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" NOT IN ('2017-06-30', '2017-07-01')"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"date\" NOT IN ('2017-06-30', '2017-07-01'))"
              )

              keyword = 'date:!=2017-06-30,2017-07-01'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" NOT IN ('2017-06-30', '2017-07-01')"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"date\" NOT IN ('2017-06-30', '2017-07-01'))"
              )

              keyword = 'date:<>2017-06-30,2017-07-01'
              expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
                {
                  5 => {
                    2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"date\" NOT IN ('2017-06-30', '2017-07-01')"
                  }
                },
                "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"date\" NOT IN ('2017-06-30', '2017-07-01'))"
              )
            end
          end
        end

        context ':~' do
          it 'returns the matcing query' do
            keyword = 'string:~something'
            expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
              {
                5 => {
                  2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" ILIKE '%something%'"
                }
              },
              "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" ILIKE '%something%')"
            )
          end
        end

        context ':^' do
          it 'returns the matcing query' do
            keyword = 'string:^starting'
            expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
              {
                5 => {
                  2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" ILIKE 'starting%'"
                }
              },
              "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" ILIKE 'starting%')"
            )
          end
        end

        context ':$' do
          it 'returns the matcing query' do
            keyword = 'string:$ending'
            expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
              {
                5 => {
                  2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" ILIKE '%ending'"
                }
              },
              "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" ILIKE '%ending')"
            )
          end
        end

        context ':!~' do
          it 'returns the matcing query' do
            keyword = 'string:!~something'
            expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
              {
                5 => {
                  2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" NOT ILIKE '%something%'"
                }
              },
              "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" NOT ILIKE '%something%')"
            )
          end
        end

        context ':!^' do
          it 'returns the matcing query' do
            keyword = 'string:!^starting'
            expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
              {
                5 => {
                  2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" NOT ILIKE 'starting%'"
                }
              },
              "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" NOT ILIKE 'starting%')"
            )
          end
        end

        context ':!$' do
          it 'returns the matcing query' do
            keyword = 'string:!$ending'
            expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
              {
                5 => {
                  2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE \"all_postgres_types\".\"string\" NOT ILIKE '%ending'"
                }
              },
              "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (\"all_postgres_types\".\"string\" NOT ILIKE '%ending')"
            )
          end
        end

        context ':>' do
          it 'returns the comparing query' do
            keyword = 'integer:>100'
            expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
              {
                5 => {
                  2 => 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" > 100'
                }
              },
              'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" > 100)'
            )
          end
        end

        context ':>=' do
          it 'returns the comparing query' do
            keyword = 'integer:>=100'
            expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
              {
                5 => {
                  2 => 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" >= 100'
                }
              },
              'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" >= 100)'
            )
          end
        end

        context ':<' do
          it 'returns the comparing query' do
            keyword = 'integer:<100'
            expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
              {
                5 => {
                  2 => 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" < 100'
                }
              },
              'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" < 100)'
            )
          end
        end

        context ':<=' do
          it 'returns the comparing query' do
            keyword = 'integer:<=100'
            expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
              {
                5 => {
                  2 => 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" <= 100'
                }
              },
              'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" <= 100)'
            )
          end
        end

        context ':()' do
          it 'returns the comparing query' do
            keyword = 'integer:()100,999'
            expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
              {
                5 => {
                  2 => 'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE "all_postgres_types"."integer" BETWEEN 100 AND 999'
                }
              },
              'SELECT "all_postgres_types".* FROM "all_postgres_types" WHERE ("all_postgres_types"."integer" BETWEEN 100 AND 999)'
            )
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
          expect { subject.search(parameters(q: keyword)).to_sql }.to raise_error Wallaby::UnprocessableEntity
        end
      end
    end

    describe 'complex search' do
      before do
        model_decorator.filters[:boolean] = { scope: -> { where boolean: true } }
      end

      it 'returns search result' do
        keyword = 'keyword integer:!=1 date:>2016-04-30'
        # byebug
        expect(subject.search(parameters(q: keyword)).to_sql).to eq minor(
          {
            5 => {
              2 => "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE (((\"all_postgres_types\".\"color\" ILIKE '%keyword%' OR \"all_postgres_types\".\"email\" ILIKE '%keyword%') OR \"all_postgres_types\".\"password\" ILIKE '%keyword%') OR \"all_postgres_types\".\"string\" ILIKE '%keyword%') AND \"all_postgres_types\".\"integer\" != 1 AND \"all_postgres_types\".\"date\" > '2016-04-30'"
            }
          },
          "SELECT \"all_postgres_types\".* FROM \"all_postgres_types\" WHERE ((((\"all_postgres_types\".\"color\" ILIKE '%keyword%' OR \"all_postgres_types\".\"email\" ILIKE '%keyword%') OR \"all_postgres_types\".\"password\" ILIKE '%keyword%') OR \"all_postgres_types\".\"string\" ILIKE '%keyword%') AND \"all_postgres_types\".\"integer\" != 1 AND \"all_postgres_types\".\"date\" > '2016-04-30')"
        )
      end
    end
  end
end
