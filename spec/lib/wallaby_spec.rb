require 'rails_helper'

describe Wallaby do
  describe '.config' do
    it 'updates the configuration' do
      described_class.config do |c|
        c.base_controller = ::ActionController::Base
      end
      expect(described_class.configuration.base_controller).to eq ::ActionController::Base
    end
  end
end
