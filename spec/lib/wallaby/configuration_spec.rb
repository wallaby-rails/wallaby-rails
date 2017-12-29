require 'rails_helper'

describe Wallaby::Configuration do
  describe '#base_controller' do
    it 'returns ApplicationController by default' do
      expect(subject.base_controller).to eq ::ApplicationController
    end

    it 'returns whatever is set' do
      subject.base_controller = ::ActionController::Base
      expect(subject.base_controller).to eq ::ActionController::Base
    end
  end

  describe '#models' do
    it 'returns ApplicationController by default' do
      subject.models = AllPostgresType
      expect(subject.models.presence).to eq [AllPostgresType]

      subject.models = [AllPostgresType, AllMysqlType]
      expect(subject.models.presence).to eq [AllPostgresType, AllMysqlType]
    end
  end

  describe '#security' do
    it 'returns the configuration of security' do
      expect(subject.security).to be_a Wallaby::Configuration::Security
    end
  end

  describe '#pagination' do
    it 'returns the configuration of pagination' do
      expect(subject.pagination).to be_a Wallaby::Configuration::Pagination
    end
  end

  describe '#metadata' do
    it 'returns the configuration of metadata' do
      expect(subject.metadata).to be_a Wallaby::Configuration::Metadata
    end
  end

  describe '#features' do
    it 'returns the configuration of features' do
      expect(subject.features).to be_a Wallaby::Configuration::Features
    end
  end
end
