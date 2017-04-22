require 'rails_helper'

describe Wallaby::Map do
  describe '.mode_map' do
    before do
      class SuperMode
        def self.model_finder; Finder; end
        class Finder
          def all; [AllPostgresType, AllMysqlType, AllSqliteType]; end
        end
      end
      expect(Wallaby::Mode).to receive(:subclasses) { [SuperMode] }
    end

    it 'returns a map of model -> mode' do
      expect(described_class.mode_map).to eq \
        AllPostgresType => SuperMode,
        AllMysqlType => SuperMode,
        AllSqliteType => SuperMode
    end

    it 'memorizes the map' do
      expect(described_class::ModeMapper) \
        .to receive(:new).once.and_return(double(map: []))
      described_class.mode_map
      described_class.mode_map
      described_class.mode_map
    end
  end

  describe '.controller_map' do
    before do
      class FashionController1
        def self.model_class; AllPostgresType; end
      end
      class FashionController2
        def self.model_class; AllMysqlType; end
      end
      expect(Wallaby::ResourcesController).to receive(:subclasses) {
        [FashionController1, FashionController2]
      }
    end

    it 'returns a map of model -> controller' do
      expect(described_class.controller_map).to eq \
        AllPostgresType => FashionController1,
        AllMysqlType => FashionController2
    end

    it 'memorizes the map' do
      described_class.controller_map
      described_class.controller_map
      described_class.controller_map
    end
  end

  describe '.decorator_map' do
    before do
      class FashionDecorator1
        def self.model_class; AllPostgresType; end
      end
      class FashionDecorator2
        def self.model_class; AllMysqlType; end
      end
      expect(Wallaby::ResourceDecorator).to receive(:subclasses) {
        [FashionDecorator1, FashionDecorator2]
      }
    end

    it 'returns a map of model -> decorator' do
      expect(described_class.decorator_map).to eq \
        AllPostgresType => FashionDecorator1,
        AllMysqlType => FashionDecorator2
    end

    it 'memorizes the map' do
      described_class.decorator_map
      described_class.decorator_map
      described_class.decorator_map
    end
  end

  describe '.servicer_map' do
    before do
      class FashionServicer1
        def self.model_class; AllPostgresType; end
      end
      class FashionServicer2
        def self.model_class; AllMysqlType; end
      end
      expect(Wallaby::ModelServicer).to receive(:subclasses) {
        [FashionServicer1, FashionServicer2]
      }
    end

    it 'returns a map of model -> servicer' do
      expect(described_class.servicer_map).to eq \
        AllPostgresType => FashionServicer1,
        AllMysqlType => FashionServicer2
    end

    it 'memorizes the map' do
      described_class.servicer_map
      described_class.servicer_map
      described_class.servicer_map
    end
  end

  describe '.model_classes' do
    let(:configuration) { Wallaby::Configuration.new }

    before do
      expect(Wallaby::Mode).to receive(:subclasses) { [SuperMode] }
      expect(Wallaby).to receive(:configuration) { configuration }
    end

    it 'returns all models' do
      expect(described_class.model_classes).to eq \
        [AllPostgresType, AllMysqlType, AllSqliteType]
    end

    context 'there are excludes' do
      before do
        configuration.models.exclude AllPostgresType
      end

      it 'excludes AllPostgresType' do
        expect(described_class.model_classes).to \
          eq [AllMysqlType, AllSqliteType]
      end

      context 'models are set' do
        before do
          configuration.models.set AllSqliteType
        end

        it 'returns the models being set' do
          expect(described_class.model_classes).to eq [AllSqliteType]
        end

        context 'some of the models being set are invalid' do
          before do
            configuration.models.set SuperMode, AllSqliteType
          end

          it 'raises error' do
            expect { described_class.model_classes }.to \
              raise_error Wallaby::InvalidError
          end
        end
      end
    end

    it 'memorizes the map' do
      described_class.model_classes
      described_class.model_classes
      described_class.model_classes
    end
  end
end
