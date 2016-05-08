require 'rails_helper'

describe Wallaby::Mode do
  Wallaby::Mode::INTERFACE_METHODS.each do |method_id|
    describe ".#{ method_id }" do
      let(:klass_name) { "#{ described_class }::#{ method_class }"}
      let(:method_class) { method_id.classify }

      it 'raises not implemented for class' do
        expect{ described_class.send method_id }.to raise_error Wallaby::NotImplemented, klass_name
      end
    end
  end
end
