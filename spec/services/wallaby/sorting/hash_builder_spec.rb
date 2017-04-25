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
end
