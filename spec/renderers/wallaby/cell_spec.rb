require 'rails_helper'

describe Wallaby::Cell, type: :helper do
  subject { described_class.new helper, object: AllPostgresType.new }

  describe '#respond_to_missing?' do
    it 'responds to view methods' do
      expect(subject.respond_to?(:raw)).to be_truthy
      expect(subject.respond_to?(:locals)).to be_truthy
      expect(subject.respond_to?(:unknown)).to be_falsy
    end
  end
end
