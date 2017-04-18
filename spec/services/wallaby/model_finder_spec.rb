require 'rails_helper'

describe Wallaby::ModelFinder do
  describe '#all' do
    it 'raises not implemented error' do
      expect { subject.send :all }.to raise_error Wallaby::NotImplemented
    end
  end
end
