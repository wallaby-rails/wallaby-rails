# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::FieldsRegulator do
  subject { described_class.new(fields) }

  let(:fields) { {} }

  describe '#execute' do
    it { expect(subject.execute).to be_a ActiveSupport::HashWithIndifferentAccess }

    context 'when fields is not a hash' do
      let(:fields) { 'String' }

      it { expect { subject.execute }.to raise_error ArgumentError, 'Please provide a Hash metadata' }
    end

    context 'when fields does not have type' do
      let(:fields) { { id: { type: 'integer' }, name: {} } }

      it { expect { subject.execute }.to raise_error ArgumentError, 'Please provide the type for name' }
    end
  end
end
