# frozen_string_literal: true

require 'rails_helper'

# Security regression specs for the Pundit authorization provider.
#
# Covers OWASP A01: a missing policy must fail closed (403) instead of raising
# an unhandled error (500). See the audit finding L6.
describe Wallaby::PunditAuthorizationProvider do
  let(:user) { instance_double 'user' }
  let(:subject_instance) { Struct.new(:id).new(1) }
  let(:provider) { described_class.new(user: user) }

  describe '#authorize' do
    context 'when no policy is defined' do
      before do
        allow(Pundit).to receive(:authorize).and_raise(Pundit::NotDefinedError)
      end

      it 'raises Forbidden instead of leaking an error' do
        expect { provider.authorize(:show, subject_instance) }
          .to raise_error Wallaby::Forbidden
      end
    end
  end

  describe '#authorized?' do
    context 'when no policy is defined' do
      before do
        allow(Pundit).to receive(:policy!).and_raise(Pundit::NotDefinedError)
      end

      it 'returns false' do
        expect(provider.authorized?(:show, subject_instance)).to be false
      end
    end
  end

  describe '#accessible_for' do
    context 'when no scope policy is defined' do
      let(:scope) { double }

      before do
        allow(Pundit).to receive(:policy_scope!).and_raise(Pundit::NotDefinedError)
      end

      it 'returns the original scope' do
        expect(provider.accessible_for(:index, scope)).to be scope
      end
    end
  end
end
