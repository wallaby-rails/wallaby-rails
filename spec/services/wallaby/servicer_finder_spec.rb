require 'rails_helper'

describe Wallaby::ServicerFinder, clear: :object_space do
  describe '#find' do
    it 'finds the servicer' do
      stub_const 'ProductServicer', Class.new(Wallaby::ModelServicer)

      expect(Wallaby::ServicerFinder.find(Product)).to eq ProductServicer
      expect(Wallaby::ServicerFinder.find(Category)).to \
        eq Wallaby::ModelServicer
    end
  end
end
