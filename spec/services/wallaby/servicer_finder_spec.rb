require 'rails_helper'

describe Wallaby::ServicerFinder do
  describe '#find' do
    it 'finds the servicer' do
      stub_const 'ProductServicer', Class.new(Wallaby::ModelServicer)
      allow(Wallaby).to receive_message_chain(:configuration, :adaptor, :model_servicer) { Wallaby::ModelServicer }
      allow(Wallaby::ServicerFinder).to receive(:cached_subclasses) { [ ProductServicer ] }

      expect(Wallaby::ServicerFinder.find Product).to eq ProductServicer
      expect(Wallaby::ServicerFinder.find Category).to eq Wallaby::ModelServicer
    end
  end
end
