require 'rails_helper'

describe Wallaby::ModelServiceProvider do
  subject { described_class.new AllPostgresType }

  %w(permit collection paginate new find create update destroy).each do |method|
    describe "##{method}" do
      it 'raises not implemented' do
        arity = subject.method(method).arity
        expect { subject.public_send(method, *arity.times.to_a) }.to raise_error Wallaby::NotImplemented
      end
    end
  end
end
