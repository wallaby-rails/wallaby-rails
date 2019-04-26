require 'rails_helper'

describe Wallaby::ModelDecorator do
  subject { described_class.new AllPostgresType }

  %w(fields index_fields index_field_names show_fields show_field_names form_fields form_field_names form_active_errors primary_key guess_title).each do |method|
    describe "##{method}" do
      it 'raises not implemented' do
        arity = subject.method(method).arity
        expect { subject.public_send(method, *arity.times.to_a) }.to raise_error Wallaby::NotImplemented
      end
    end
  end
end
