require 'rails_helper'
require 'wallaby/version'
require 'wallaby/active_record'
require 'wallaby/her'

describe Wallaby do
  describe '.config' do
    it 'updates the configuration' do
      described_class.config do |c|
        c.base_controller = ::ActionController::Base
      end
      expect(described_class.configuration.base_controller).to eq ::ActionController::Base
    end
  end

  describe '::version' do
    it { expect(described_class::VERSION).to be_present }
  end
end
