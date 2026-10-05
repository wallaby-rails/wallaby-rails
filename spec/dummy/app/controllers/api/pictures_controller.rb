# frozen_string_literal: true

if Rails::VERSION::MAJOR >= 5
  module Api
    class PicturesController < ActionController::API
      include Wallaby::ResourcesConcern
      self.responder = Wallaby::JsonApiResponder

      # SECURITY: dummy-app only; opts out of the fail-closed authentication so
      # the JSON API can be exercised in the test suite.
      def authenticate_wallaby_user!
        true
      end
    end
  end
end
