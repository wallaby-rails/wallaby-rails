# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ConfigurationHelper, type: :helper do
  describe '#configuration' do
    it { expect(helper.configuration).to be_a Wallaby::Configuration }
  end

  describe '#wallaby_controller' do
    it { expect(helper.wallaby_controller).to eq Wallaby::ResourcesController }
  end

  describe '#max_text_length' do
    it { expect(helper.max_text_length).to eq Wallaby::DEFAULT_MAX }
  end
end
