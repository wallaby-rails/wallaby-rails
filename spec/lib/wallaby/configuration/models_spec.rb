require 'rails_helper'

describe Wallaby::Configuration::Models do
  describe '#set' do
    it 'saves the model as string' do
      expect(subject.set(AllPostgresType)).to eq ['AllPostgresType']
      expect(subject.set([AllPostgresType])).to eq ['AllPostgresType']
      expect(subject.set('AllPostgresType')).to eq ['AllPostgresType']
      expect(subject.set(['AllPostgresType'])).to eq ['AllPostgresType']
    end
  end

  describe '#presence' do
    it 'returns presence of models' do
      expect(subject.presence).to eq []
      subject.set AllPostgresType
      expect(subject.presence).to eq [AllPostgresType]
    end
  end

  describe 'excludes' do
    it 'returns blank array by default' do
      expect(subject.excludes).to eq [ActiveRecord::SchemaMigration]
    end

    it 'returns whatever has been assigned' do
      models = %w(Hash Array)
      models_constants = [Hash, Array]

      subject.exclude(*models)
      expect(subject.excludes).to eq models_constants

      subject.exclude(*models_constants)
      expect(subject.excludes).to eq models_constants
    end

    it 'sets blank array' do
      subject.exclude([])
      expect(subject.excludes).to be_blank
    end
  end
end
