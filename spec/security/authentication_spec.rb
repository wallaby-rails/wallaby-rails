# frozen_string_literal: true

require 'rails_helper'

# Security regression specs for authentication / authorization defaults.
#
# Covers OWASP A01/A07: Wallaby must fail closed. If the host has not provided
# authentication, requests must be rejected (401) instead of being allowed.
# See the audit finding C2.
describe 'Wallaby authentication defaults', type: :request do
  describe 'fail-closed authentication' do
    context 'when the controller does not provide authentication' do
      it 'denies the request with 401' do
        # The dummy JSON API controller opts out; a controller without any
        # opt-in must be rejected. We exercise the concern directly here.
        base = Class.new do
          def try(method_name, *args)
            respond_to?(method_name) ? public_send(method_name, *args) : nil
          end

          # Minimal stand-ins required by the concern.
          def self.rescue_from(*); end

          def helper_method(*); end
        end
        object = base.new
        object.extend Wallaby::AuthenticationConcern

        expect { object.authenticate_wallaby_user! }
          .to raise_error Wallaby::NotAuthenticated
      end
    end

    context 'when authentication is explicitly provided' do
      it 'allows the request' do
        base = Class.new do
          def try(method_name, *args)
            respond_to?(method_name) ? public_send(method_name, *args) : nil
          end

          def authenticate_user!
            true
          end
        end
        object = base.new
        object.extend Wallaby::AuthenticationConcern

        expect(object.authenticate_wallaby_user!).to be_truthy
      end
    end

    context 'when authentication returns false' do
      it 'denies the request' do
        base = Class.new do
          def try(method_name, *args)
            respond_to?(method_name) ? public_send(method_name, *args) : nil
          end

          def authenticate_user!
            false
          end
        end
        object = base.new
        object.extend Wallaby::AuthenticationConcern

        expect { object.authenticate_wallaby_user! }
          .to raise_error Wallaby::NotAuthenticated
      end
    end
  end

  describe 'default authorization provider' do
    it 'is fail-open and therefore warns loudly' do
      expect(Wallaby::Logger).to receive(:warn).with(a_string_including('default authorization provider'))

      Wallaby::ModelAuthorizer.warn_on_default_provider(
        Wallaby::DefaultAuthorizationProvider
      )
    end

    it 'does not warn for a real provider' do
      expect(Wallaby::Logger).not_to receive(:warn)

      Wallaby::ModelAuthorizer.warn_on_default_provider(
        Wallaby::CancancanAuthorizationProvider
      )
    end
  end
end
