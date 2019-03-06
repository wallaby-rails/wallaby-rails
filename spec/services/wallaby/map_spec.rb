require 'rails_helper'

class SuperMode
  def self.model_finder
    Finder
  end
  class Finder
    def all
      [AllPostgresType, AllMysqlType, AllSqliteType]
    end
  end
end

describe Wallaby::Map do
  describe 'using SuperMode' do
    before do
      described_class.modes = [SuperMode]
    end

    describe '.mode_map' do
      it 'returns a map of model -> mode' do
        expect(described_class.mode_map).to eq \
          AllPostgresType => SuperMode,
          AllMysqlType => SuperMode,
          AllSqliteType => SuperMode
      end

      it 'is frozen' do
        expect { described_class.mode_map[Array] = SuperMode }.to raise_error RuntimeError, "can't modify frozen Hash"
      end
    end

    describe 'application classes' do
      describe '.controller_map' do
        let!(:base_controller) { Wallaby::ResourcesController }
        let!(:admin_controller) { stub_const 'Admin::ApplicationController', (Class.new(base_controller) { base_class! }) }
        let!(:user_controller) { stub_const 'UserController', (Class.new(base_controller) { base_class! }) }
        let!(:all_postgres_types_controller) { stub_const 'AllPostgresTypesController', Class.new(admin_controller) }
        let!(:mysql_types_controller) { stub_const 'MysqlTypesController', (Class.new(user_controller) { self.model_class = AllMysqlType }) }

        it 'returns a controller class' do
          expect(described_class.controller_map(Array)).to be_nil
          expect(described_class.controller_map(AllPostgresType)).to eq all_postgres_types_controller
          expect(described_class.controller_map(AllMysqlType)).to eq admin_controller
          expect(described_class.controller_map(AllSqliteType)).to eq admin_controller
          expect(described_class.controller_map(AllPostgresType, user_controller)).to eq user_controller
          expect(described_class.controller_map(AllMysqlType, user_controller)).to eq mysql_types_controller
          expect(described_class.controller_map(AllSqliteType, user_controller)).to eq user_controller
        end
      end

      describe '.resource_decorator_map' do
        let!(:base_decorator) { Wallaby::ResourceDecorator }
        let!(:admin_decorator) { stub_const 'Admin::ApplicationDecorator', Class.new(base_decorator) }
        let!(:user_decorator) { stub_const 'UserDecorator', Class.new(base_decorator) }
        let!(:all_postgres_type_decorator) { stub_const 'AllPostgresTypeDecorator', Class.new(admin_decorator) }
        let!(:mysql_type_decorator) { stub_const 'MysqlTypeDecorator', (Class.new(user_decorator) { self.model_class = AllMysqlType }) }

        it 'returns a decorator class' do
          expect(described_class.resource_decorator_map(Array)).to be_nil
          expect(described_class.resource_decorator_map(AllPostgresType)).to eq all_postgres_type_decorator
          expect(described_class.resource_decorator_map(AllMysqlType)).to eq admin_decorator
          expect(described_class.resource_decorator_map(AllSqliteType)).to eq admin_decorator
          expect(described_class.resource_decorator_map(AllPostgresType, user_decorator)).to eq user_decorator
          expect(described_class.resource_decorator_map(AllMysqlType, user_decorator)).to eq mysql_type_decorator
          expect(described_class.resource_decorator_map(AllSqliteType, user_decorator)).to eq user_decorator
        end
      end

      describe '.servicer_map' do
        let!(:base_servicer) { Wallaby::ModelServicer }
        let!(:admin_servicer) { stub_const 'Admin::ApplicationServicer', Class.new(base_servicer) }
        let!(:user_servicer) { stub_const 'UserServicer', Class.new(base_servicer) }
        let!(:all_postgres_type_servicer) { stub_const 'AllPostgresTypeServicer', Class.new(admin_servicer) }
        let!(:mysql_type_servicer) { stub_const 'MysqlTypeServicer', (Class.new(user_servicer) { self.model_class = AllMysqlType }) }

        it 'returns a servicer class' do
          expect(described_class.servicer_map(Array)).to be_nil
          expect(described_class.servicer_map(AllPostgresType)).to eq all_postgres_type_servicer
          expect(described_class.servicer_map(AllMysqlType)).to eq admin_servicer
          expect(described_class.servicer_map(AllSqliteType)).to eq admin_servicer
          expect(described_class.servicer_map(AllPostgresType, user_servicer)).to eq user_servicer
          expect(described_class.servicer_map(AllMysqlType, user_servicer)).to eq mysql_type_servicer
          expect(described_class.servicer_map(AllSqliteType, user_servicer)).to eq user_servicer
        end
      end

      describe '.paginator_map' do
        let!(:base_paginator) { Wallaby::ModelPaginator }
        let!(:admin_paginator) { stub_const 'Admin::ApplicationPaginator', Class.new(base_paginator) }
        let!(:user_paginator) { stub_const 'UserPaginator', Class.new(base_paginator) }
        let!(:all_postgres_type_paginator) { stub_const 'AllPostgresTypePaginator', Class.new(admin_paginator) }
        let!(:mysql_type_paginator) { stub_const 'MysqlTypePaginator', (Class.new(user_paginator) { self.model_class = AllMysqlType }) }

        it 'returns a paginator class' do
          expect(described_class.paginator_map(Array)).to be_nil
          expect(described_class.paginator_map(AllPostgresType)).to eq all_postgres_type_paginator
          expect(described_class.paginator_map(AllMysqlType)).to eq admin_paginator
          expect(described_class.paginator_map(AllSqliteType)).to eq admin_paginator
          expect(described_class.paginator_map(AllPostgresType, user_paginator)).to eq user_paginator
          expect(described_class.paginator_map(AllMysqlType, user_paginator)).to eq mysql_type_paginator
          expect(described_class.paginator_map(AllSqliteType, user_paginator)).to eq user_paginator
        end
      end

      describe '.authorizer_map' do
        let!(:base_authorizer) { Wallaby::ModelAuthorizer }
        let!(:admin_authorizer) { stub_const 'Admin::ApplicationAuthorizer', Class.new(base_authorizer) }
        let!(:user_authorizer) { stub_const 'UserAuthorizer', Class.new(base_authorizer) }
        let!(:all_postgres_type_authorizer) { stub_const 'AllPostgresTypeAuthorizer', Class.new(admin_authorizer) }
        let!(:mysql_type_authorizer) { stub_const 'MysqlTypeAuthorizer', (Class.new(user_authorizer) { self.model_class = AllMysqlType }) }

        it 'returns a authorizer class' do
          expect(described_class.authorizer_map(Array)).to be_nil
          expect(described_class.authorizer_map(AllPostgresType)).to eq all_postgres_type_authorizer
          expect(described_class.authorizer_map(AllMysqlType)).to eq admin_authorizer
          expect(described_class.authorizer_map(AllSqliteType)).to eq admin_authorizer
          expect(described_class.authorizer_map(AllPostgresType, user_authorizer)).to eq user_authorizer
          expect(described_class.authorizer_map(AllMysqlType, user_authorizer)).to eq mysql_type_authorizer
          expect(described_class.authorizer_map(AllSqliteType, user_authorizer)).to eq user_authorizer
        end
      end
    end
  end

  describe '.model_class_map' do
    it 'returns a model class that convert from a resources name' do
      expect(described_class.model_class_map('products')).to eq Product
    end
  end

  describe '.resources_name_map' do
    it 'returns a resources name that convert from a model class' do
      expect(described_class.resources_name_map(Product)).to eq 'products'
    end
  end

  describe 'providers' do
    describe '.model_decorator_map' do
      it 'returns a model decorator' do
        expect(described_class.model_decorator_map(Array)).to be_nil
        expect(described_class.model_decorator_map(AllPostgresType)).to be_a Wallaby::ActiveRecord::ModelDecorator
      end
    end

    describe '.service_provider_map' do
      it 'returns a model service provider' do
        expect(described_class.service_provider_map(Array)).to be_nil
        expect(described_class.service_provider_map(AllPostgresType)).to eq Wallaby::ActiveRecord::ModelServiceProvider
      end
    end

    describe '.pagination_provider_map' do
      it 'returns a model pagination provider' do
        expect(described_class.pagination_provider_map(Array)).to be_nil
        expect(described_class.pagination_provider_map(AllPostgresType)).to eq Wallaby::ActiveRecord::ModelPaginationProvider
      end
    end

    describe '.authorization_provider_map' do
      it 'returns a model authorization provider'
    end
  end
end
