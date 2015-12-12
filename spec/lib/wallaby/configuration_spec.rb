require 'rails_helper'

describe Wallaby::Configuration do
  describe 'adaptor' do
    it 'alerts when adaptor has been initialized' do
      subject.adaptor
      expect{ subject.adaptor = 'test' }.to raise_error RuntimeError
    end

    it 'returns Wallaby::ActiveRecord by default' do
      expect(subject.adaptor).to eq Wallaby::ActiveRecord
    end

    it 'responds to the following methods' do
      expect(subject.adaptor).to respond_to :model_decorator
      expect(subject.adaptor).to respond_to :model_finder
      expect(subject.adaptor).to respond_to :resource_commander
    end
  end
end