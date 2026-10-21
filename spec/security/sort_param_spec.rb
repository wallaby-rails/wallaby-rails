# frozen_string_literal: true

require 'rails_helper'

# Security regression specs: a non-string `sort` parameter must not crash the
# request.
#
# Rails parses `?sort[x]=y` into an `ActionController::Parameters`. Feeding that
# into the sort builder used to raise `NoMethodError` (an unhandled 500). See the
# security audit finding L-2.
describe Wallaby::Sorting::HashBuilder do
  describe '.build' do
    it 'treats a non-string sort as no sorting' do
      expect(described_class.build(ActionController::Parameters.new('x' => 'y'))).to eq({})
      expect(described_class.build(nil)).to eq({})
      expect(described_class.build([1, 2])).to eq({})
    end
  end
end

describe Wallaby::ActiveRecord::ModelServiceProvider::Querier do
  subject { described_class.new Wallaby::ActiveRecord::ModelDecorator.new(Product) }

  describe '#sort' do
    let(:scope) { Product.where(nil) }

    it 'ignores a non-string sort instead of raising' do
      expect { subject.sort(ActionController::Parameters.new('x' => 'y'), scope) }
        .not_to raise_error
    end

    it 'returns the scope unchanged when the sort is not a string' do
      expect(subject.sort(ActionController::Parameters.new('x' => 'y'), scope)).to eq scope
    end
  end
end
