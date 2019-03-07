require 'rails_helper'

describe Wallaby::ResourceNotFound do
  subject { described_class.new 1 }

  describe '#message' do
    it 'returns the message' do
      expect(subject.message).to eq 'Record 1 cannot be found.'
    end
  end
end
