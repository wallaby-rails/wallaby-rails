require 'rails_helper'

describe Wallaby::Configuration::Metadata do
  describe '#max' do
    it 'returns max' do
      expect(subject.max).to eq Wallaby::DEFAULT_MAX
      subject.max = 50
      expect(subject.max).to eq 50
    end
  end
end
