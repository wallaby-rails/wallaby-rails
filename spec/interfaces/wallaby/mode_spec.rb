require 'rails_helper'

describe Wallaby::Mode do
  %w(model_decorator model_finder model_service_provider model_pagination_provider).each do |method_id|
    describe ".#{method_id}" do
      let(:klass_name) { "#{described_class}::#{method_class}" }
      let(:method_class) { method_id.classify }

      it 'raises not implemented for class' do
        expect { described_class.send method_id }.to raise_error Wallaby::NotImplemented, klass_name
      end

      context 'when not inheriting the correct parent' do
        it 'railse invalid error for inheritance' do
          stub_const "#{described_class}::#{method_class}", Class.new

          expect { described_class.send method_id }.to raise_error Wallaby::InvalidError, "#{described_class}::#{method_class} must inherit Wallaby::#{method_class}"
        end
      end
    end
  end
end
