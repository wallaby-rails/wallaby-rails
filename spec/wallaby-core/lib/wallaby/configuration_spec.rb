# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Configuration do
  describe '#base_controller' do
    it_behaves_like \
      'has attribute with default value',
      :base_controller, ::ApplicationController, ::ActionController::Base
  end

  describe '#raise_on_name_error' do
    it_behaves_like \
      'has attribute with default value',
      :raise_on_name_error, nil, true
  end

  describe '#security' do
    it 'returns the configuration of security' do
      expect(subject.security).to be_a described_class::Security
    end
  end

  describe '#mapping' do
    it 'returns the configuration of mapping' do
      expect(subject.mapping).to be_a described_class::Mapping
    end
  end

  describe '#pagination' do
    it 'returns the configuration of pagination' do
      expect(subject.pagination).to be_a described_class::Pagination
    end
  end

  describe '#metadata' do
    it 'returns the configuration of metadata' do
      expect(subject.metadata).to be_a described_class::Metadata
    end
  end

  describe '#features' do
    it 'returns the configuration of features' do
      expect(subject.features).to be_a described_class::Features
    end
  end

  describe '#model_paths' do
    it 'returns model paths' do
      expect(subject.model_paths).to eq %w[app/models]
      subject.model_paths = 'app/extra', 'app/core'
      expect(subject.model_paths).to eq ['app/extra', 'app/core']
      expect { subject.model_paths = :'app/models' }.to raise_error ArgumentError, 'Please provide a list of string paths, e.g. `["app/models", "app/core"]`'
    end
  end

  describe '#clear' do
    it 'clears all the instance variables' do
      subject.base_controller
      all_vars = %i[@base_controller]
      subject.clear
      expect(subject.instance_variables.sort).to eq all_vars
      subject.instance_variables.each do |var|
        expect(subject.instance_variable_get(var)).to be_nil
      end
    end
  end
end
