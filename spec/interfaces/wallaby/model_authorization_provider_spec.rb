require 'rails_helper'

describe Wallaby::ModelAuthorizationProvider do
  describe '.available?' do
    it { expect { described_class.available?(nil) }.to raise_error Wallaby::NotImplemented }
  end

  describe '.args_from' do
    it { expect { described_class.args_from(nil) }.to raise_error Wallaby::NotImplemented }
  end

  describe '.provider_name' do
    it { expect(described_class.provider_name).to eq 'model' }
  end

  describe 'instance methods' do
    subject { described_class.new nil }
    %w(authorize authorized? unauthorized? accessible_for attributes_for permit_params).each do |method|
      describe "##{method}" do
        it 'raises not implemented' do
          arity = subject.method(method).arity
          expect { subject.public_send(method, *arity.times.to_a) }.to raise_error Wallaby::NotImplemented
        end
      end
    end
  end
end
