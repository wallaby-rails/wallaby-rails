require 'rails_helper'

describe Wallaby::Utils do
  describe '.to_resources_name' do
    it 'handles the namespace and returns resources name for a class name' do
      expect(described_class.to_resources_name 'Post').to eq 'posts'
      expect(described_class.to_resources_name 'Wallaby::Post').to eq 'wallaby::posts'
    end
  end
end