# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Sorting::HashBuilder do
  describe '.build' do
    it 'returns a sorting hash' do
      str = 'name asc'
      expect(described_class.build(str)).to eq 'name' => 'asc'

      str = 'name asc,updated_at desc'
      expect(described_class.build(str)).to eq 'name' => 'asc', 'updated_at' => 'desc'

      str = 'name  asc , updated_at  desc'
      expect(described_class.build(str)).to eq 'name' => 'asc', 'updated_at' => 'desc'

      str = 'name  asc , updated_at  desc, '
      expect(described_class.build(str)).to eq 'name' => 'asc', 'updated_at' => 'desc'

      str = 'invalid , name  asc , updated_at  desc'
      expect(described_class.build(str)).to eq 'name' => 'asc', 'updated_at' => 'desc'

      str = 'invalid value, name  asc , updated_at  desc'
      expect(described_class.build(str)).to eq 'name' => 'asc', 'updated_at' => 'desc'

      str = 'name  asc , invalid , updated_at  desc'
      expect(described_class.build(str)).to eq 'name' => 'asc', 'updated_at' => 'desc'

      str = 'name  asc , invalid value, updated_at  desc'
      expect(described_class.build(str)).to eq 'name' => 'asc', 'updated_at' => 'desc'

      str = 'name  asc , updated_at  desc, invalid'
      expect(described_class.build(str)).to eq 'name' => 'asc', 'updated_at' => 'desc'

      str = 'name  asc , updated_at  desc, invalid value'
      expect(described_class.build(str)).to eq 'name' => 'asc', 'updated_at' => 'desc'
    end
  end

  describe '.to_str' do
    it 'returns a sorting string' do
      hash = { 'name' => 'asc' }
      expect(described_class.to_str(hash)).to eq 'name asc'

      hash = { 'name' => 'asc', 'updated_at' => 'desc' }
      expect(described_class.to_str(hash)).to eq 'name asc,updated_at desc'

      hash = { 'name' => 'asc nulls last', 'updated_at' => 'desc nulls first' }
      expect(described_class.to_str(hash)).to eq 'name asc nulls last,updated_at desc nulls first'

      hash = { 'name' => 'invalid sort', 'updated_at' => 'desc' }
      expect(described_class.to_str(hash)).to eq 'updated_at desc'

      hash = { 'name' => 'asc nulls', 'updated_at' => 'desc' }
      expect(described_class.to_str(hash)).to eq 'updated_at desc'

      hash = { 'name' => 'asc nulls unknown', 'updated_at' => 'desc' }
      expect(described_class.to_str(hash)).to eq 'updated_at desc'
    end
  end
end
