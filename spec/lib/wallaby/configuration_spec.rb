require 'rails_helper'

describe Wallaby::Configuration do
  describe 'adaptor' do
    it 'alerts when adaptor has been initialized' do
      subject.adaptor
      expect { subject.adaptor = 'test' }.to raise_error RuntimeError
    end

    it 'returns Wallaby::ActiveRecord by default' do
      expect(subject.adaptor).to eq Wallaby::ActiveRecord
    end

    it 'responds to the following methods' do
      expect(subject.adaptor).to respond_to :model_decorator
      expect(subject.adaptor).to respond_to :model_finder
      expect(subject.adaptor).to respond_to :model_operator
    end
  end

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
