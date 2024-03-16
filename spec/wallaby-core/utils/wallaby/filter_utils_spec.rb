# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::FilterUtils do
  describe '.filter_name_by' do
    it 'returns filter name' do
      expect(described_class.filter_name_by(nil, {})).to eq :all
      expect(described_class.filter_name_by(:featured, {})).to eq :featured
      expect(described_class.filter_name_by(nil, featured: { default: true })).to eq :featured
    end
  end
end
