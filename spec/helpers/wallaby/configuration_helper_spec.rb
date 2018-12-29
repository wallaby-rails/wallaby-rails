require 'rails_helper'

describe Wallaby::ConfigurationHelper do
  describe '#configuration' do
    it { expect(helper.configuration).to be_a Wallaby::Configuration }
  end

  describe '#models' do
    it { expect(helper.models).to be_a Wallaby::Configuration::Models }
  end

  describe '#security' do
    it { expect(helper.security).to be_a Wallaby::Configuration::Security }
  end

  describe '#mapping' do
    it { expect(helper.mapping).to be_a Wallaby::Configuration::Mapping }
  end

  describe '#default_metadata' do
    it { expect(helper.default_metadata).to be_a Wallaby::Configuration::Metadata }
  end

  describe '#pagination' do
    it { expect(helper.pagination).to be_a Wallaby::Configuration::Pagination }
  end

  describe '#features' do
    it { expect(helper.features).to be_a Wallaby::Configuration::Features }
  end
end
