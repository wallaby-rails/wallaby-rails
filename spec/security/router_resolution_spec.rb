# frozen_string_literal: true

require 'rails_helper'

# Security regression specs for resource resolution.
#
# Covers OWASP A01/A03: request-provided resource names must not be
# `constantize`d directly, and unknown resources must 404 rather than raising
# unexpected errors. See the audit finding M1.
describe Wallaby::ResourcesRouter do
  describe '#call resource resolution' do
    let(:mocked_env) do
      Hash(
        ActionDispatch::Http::Parameters::PARAMETERS_KEY => params,
        'SCRIPT_NAME' => '/admin',
        'rack.input' => StringIO.new,
        'REQUEST_METHOD' => 'GET'
      )
    end

    let(:params) { { resources: resources_name, action: 'index' } }
    let(:mocked_action) { ->(_env) { [404, {}, []] } }
    let(:default_controller) { Admin::ApplicationController }

    context 'when resources name maps to a known model' do
      let(:resources_name) { 'products' }

      it 'dispatches normally' do
        expect(default_controller).to receive(:action).with('index') { mocked_action }
        subject.call mocked_env
      end
    end

    context 'when resources name is unknown' do
      let(:resources_name) { 'does_not_exist_at_all' }

      it 'treats it as not found' do
        expect(default_controller).to receive(:action).with(:not_found) { mocked_action }
        subject.call mocked_env
      end
    end

    context 'when resources name attempts path traversal / class abuse' do
      let(:resources_name) { '../../etc/passwd' }

      it 'does not dispatch a successful index and rejects the request' do
        expect(default_controller).not_to receive(:action).with('index')
        expect(default_controller).to receive(:action).with(:unprocessable_entity) { mocked_action }
        subject.call mocked_env
      end
    end

    context 'when resources name points at a core constant that is not a model' do
      let(:resources_name) { 'strings' }

      it 'does not dispatch a successful index and rejects the request' do
        expect(default_controller).not_to receive(:action).with('index')
        expect(default_controller).to receive(:action).with(:unprocessable_entity) { mocked_action }
        subject.call mocked_env
      end
    end
  end
end
