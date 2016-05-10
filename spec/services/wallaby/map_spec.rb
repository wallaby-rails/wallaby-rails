require 'rails_helper'

describe Wallaby::Map do
  before do
    allow_any_instance_of(Wallaby::ActiveRecord::ModelFinder).to receive(:all) { [ AllPostgresType, AllMysqlType, AllSqliteType ] }
  end

  describe '.mode_map' do
    before do
      expect(Wallaby::Mode).to receive(:subclasses) { Array Wallaby::ActiveRecord }
    end
    it 'returns a map for model -> mode' do
      expect(described_class.mode_map).to eq AllPostgresType => Wallaby::ActiveRecord, AllMysqlType => Wallaby::ActiveRecord, AllSqliteType => Wallaby::ActiveRecord
    end
  end

  describe '.model_classes' do
    before do
      expect(Wallaby::Mode).to receive(:subclasses) { Array Wallaby::ActiveRecord }
    end
    it 'returns model classes' do
      expect(described_class.model_classes).to eq [ AllPostgresType, AllMysqlType, AllSqliteType ]
    end

    describe 'model filter' do
      let(:configuration) { Wallaby::Configuration.new }

      context 'when models is set' do
        it 'returns models' do
          configuration.models = [ AllPostgresType, AllMysqlType ]
          expect(described_class.model_classes configuration).to eq [ AllPostgresType, AllMysqlType ]
        end

        context 'when models has invalid model' do
          it 'raises invalid error' do
            stub_const 'InvalidModel', Class.new
            configuration.models = [ InvalidModel ]
            expect{ described_class.model_classes configuration }.to raise_error Wallaby::InvalidError, "InvalidModel are invalid models."
          end
        end
      end

      context 'when exclude is set' do
        it 'returns models without excludes' do
          configuration.models.exclude AllPostgresType, AllSqliteType
          expect(described_class.model_classes configuration).to eq [ AllMysqlType ]
        end
      end
    end
  end

  describe '.controller_map' do
    it 'returns model decorators' do
      expect(described_class.controller_map.values).to all be_a Wallaby::ResourcesController
    end
  end

  describe '.decorator_map' do
    it 'returns model decorators' do
      expect(described_class.controller_map.values).to all be_a Wallaby::ResourceDecorator
    end
  end

  describe '.controller_map' do
    it 'returns model decorators' do
      expect(described_class.controller_map.values).to all be_a Wallaby::ModelServicer
    end
  end
end
