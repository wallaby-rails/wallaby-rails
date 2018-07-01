require 'rails_helper'

describe Wallaby::Configuration do
  describe '#base_controller' do
    it_behaves_like \
      'has attribute with default value',
      :base_controller, ::ApplicationController, ::ActionController::Base
  end

  describe '#models' do
    it 'returns a list of models' do
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

  describe '#mapping' do
    it 'returns the configuration of mapping' do
      expect(subject.mapping).to be_a Wallaby::Configuration::Mapping
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

  describe '#clear' do
    it 'clears all the instance variables' do
      subject.base_controller
      all_vars = %i(@base_controller)
      subject.clear
      expect(subject.instance_variables.sort).to eq all_vars
      subject.instance_variables.each do |var|
        expect(subject.instance_variable_get(var)).to be_nil
      end
    end
  end
end
