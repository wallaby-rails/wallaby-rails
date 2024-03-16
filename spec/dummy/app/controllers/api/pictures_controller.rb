# frozen_string_literal: true

if Rails::VERSION::MAJOR >= 5
  module Api
    class PicturesController < ActionController::API
      include Wallaby::ResourcesConcern
      self.responder = Wallaby::JsonApiResponder
    end
  end
end
