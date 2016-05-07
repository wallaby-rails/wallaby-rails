require 'rails_helper'

describe Wallaby::Mode do
  Wallaby::Mode::INTERFACE_METHODS.each do |method_id|
    describe ".#{ method_id }" do
      it 'raises not implemented' do
        expect{ described_class.send method_id }.to raise_error Wallaby::NotImplemented, "#{ described_class.name }::#{ method_id.classify }"
      end
    end
  end
end
