require 'rails_helper'

describe Wallaby::Mode do
  Wallaby::Mode::INTERFACE_METHODS.each do |method_id|
    describe ".#{ method_id }" do
      let(:klass_name) { "#{ described_class }::#{ method_class }"}
      let(:method_class) { method_id.classify }

      it 'raises not implemented for class' do
        expect{ described_class.send method_id }.to raise_error Wallaby::NotImplemented, klass_name
      end
    end
  end

  describe 'model class related' do
    before do
      expect(described_class).to receive(:subclasses) { Array Wallaby::ActiveRecord }
      expect_any_instance_of(Wallaby::ActiveRecord::ModelFinder).to receive(:available) { [ AllPostgresType, AllMysqlType, AllSqliteType ] }
    end

    describe '.mode_map' do
      it 'returns a map for model -> mode' do
        expect(described_class.mode_map).to eq AllPostgresType => Wallaby::ActiveRecord, AllMysqlType => Wallaby::ActiveRecord, AllSqliteType => Wallaby::ActiveRecord
      end
    end

    describe '.model_classes' do
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
  end
end
