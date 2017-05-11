require 'rails_helper'

class SuperMode
  def self.model_finder; Finder; end

  class Finder
    def all; [AllPostgresType, AllMysqlType, AllSqliteType]; end
  end
end

describe Wallaby::Map do
  describe '.mode_map' do
    before do
      expect(Wallaby::Mode).to receive(:subclasses) { [SuperMode] }
    end

    it 'returns a map of model -> mode' do
      expect(described_class.mode_map).to eq \
        AllPostgresType => SuperMode,
        AllMysqlType => SuperMode,
        AllSqliteType => SuperMode
    end

    it 'is frozen' do
      expect { described_class.mode_map[Object] = SuperMode }.to raise_error RuntimeError, "can't modify frozen Hash"
    end
  end

  describe '.model_classes' do
    before do
      expect(Wallaby::Mode).to receive(:subclasses) { [SuperMode] }
    end

    after do
      Wallaby.configuration.clear
    end

    it 'returns all models' do
      expect(described_class.model_classes).to eq [AllPostgresType, AllMysqlType, AllSqliteType]
    end

    context 'there are excludes' do
      before do
        Wallaby.configuration.models.exclude AllPostgresType
      end

      it 'excludes AllPostgresType' do
        expect(described_class.model_classes).to eq [AllMysqlType, AllSqliteType]
      end

      context 'models are set' do
        before do
          Wallaby.configuration.models.set AllSqliteType
        end

        it 'returns the models being set' do
          expect(described_class.model_classes).to eq [AllSqliteType]
        end

        context 'some of the models being set are invalid' do
          before do
            Wallaby.configuration.models.set SuperMode, AllSqliteType
          end

          it 'raises error' do
            expect { described_class.model_classes }.to \
              raise_error Wallaby::InvalidError
          end
        end
      end
    end

    it 'is frozen' do
      expect { described_class.model_classes << Object }.to raise_error RuntimeError, "can't modify frozen Array"
    end
  end

  describe '.controller_map' do
    before do
      class AllPostgresTypeController < Wallaby::ResourcesController; end
      class MysqlTypeController < Wallaby::ResourcesController
        def self.model_class; AllMysqlType; end
      end
      expect(Wallaby::ResourcesController).to receive(:subclasses) {
        [AllPostgresTypeController, MysqlTypeController]
      }
    end

    it 'returns a controller' do
      expect(described_class.controller_map(AllPostgresType)).to eq AllPostgresTypeController
      expect(described_class.instance_variable_get(:@controller_map)).to eq \
        AllPostgresType => AllPostgresTypeController,
        AllMysqlType => MysqlTypeController
      expect(described_class.controller_map(Object)).to eq Wallaby::ResourcesController
    end
  end

  describe '.model_decorator_map' do
    it 'returns a model decorator' do
      expect(described_class.model_decorator_map(AllPostgresType)).to be_a Wallaby::ActiveRecord::ModelDecorator
      expect(described_class.model_decorator_map(Array)).to be_blank
    end
  end

  describe '.resource_decorator_map' do
    before do
      class AllPostgresTypeDecorator < Wallaby::ResourceDecorator; end
      class MysqlTypeDecorator < Wallaby::ResourceDecorator
        def self.model_class; AllMysqlType; end
      end
      expect(Wallaby::ResourceDecorator).to receive(:subclasses) {
        [AllPostgresTypeDecorator, MysqlTypeDecorator]
      }
    end

    it 'returns a model decorator' do
      expect(described_class.resource_decorator_map(AllPostgresType)).to eq AllPostgresTypeDecorator
      expect(described_class.instance_variable_get(:@resource_decorator_map)).to eq \
        AllPostgresType => AllPostgresTypeDecorator,
        AllMysqlType => MysqlTypeDecorator
    end

    context 'when a model is not in the map' do
      it 'returns a general resource decorator' do
        expect(described_class.resource_decorator_map(Picture)).to eq Wallaby::ResourceDecorator
      end
    end
  end

  describe '.servicer_map' do
    before do
      class AllPostgresTypeServicer < Wallaby::ModelServicer; end
      class MysqlTypeServicer < Wallaby::ModelServicer
        def self.model_class; AllMysqlType; end
      end
      expect(Wallaby::ModelServicer).to receive(:subclasses) {
        [AllPostgresTypeServicer, MysqlTypeServicer]
      }
    end

    it 'returns a map of model -> servicer' do
      expect(described_class.servicer_map(AllPostgresType)).to be_a AllPostgresTypeServicer
      map = described_class.instance_variable_get(:@servicer_map)
      expect(map[AllPostgresType]).to be_a AllPostgresTypeServicer
      expect(map[AllMysqlType]).to be_a MysqlTypeServicer
    end
  end

  describe '.model_class_map' do
    it 'returns a model_class that convert from a resources_name' do
      expect(described_class.model_class_map('products')).to eq Product
    end
  end

  describe '.resources_name_map' do
    it 'returns a model_class that convert from a resources_name' do
      expect(described_class.resources_name_map(Product)).to eq 'products'
    end
  end
end
