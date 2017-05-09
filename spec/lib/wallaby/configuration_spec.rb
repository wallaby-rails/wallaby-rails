require 'rails_helper'

describe Wallaby::Configuration do
  describe 'base_controller' do
    it 'returns ApplicationController by default' do
      expect(subject.base_controller).to eq ::ApplicationController
    end

    it 'returns whatever is set' do
      subject.base_controller = ::ActionController::Base
      expect(subject.base_controller).to eq ::ActionController::Base
    end
  end
end
