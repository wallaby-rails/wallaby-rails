require 'rails_helper'

describe Wallaby::Her::ModelFinder, clear: :object_space do
  describe '#all' do
    it 'returns valid model classes in alphabetic order' do
      expect(subject.all).to match_array [Her::Order, Her::Category, Her::Picture, Her::Product]
    end

    context 'when there is anonymous class' do
      it 'filters out anonymous class' do
        anonymous_class = Class.new { include Her::Model }
        expect(subject.all).not_to include anonymous_class
      end
    end
  end
end
