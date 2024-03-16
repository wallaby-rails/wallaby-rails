# frozen_string_literal: true

module Resources
  class PicturesController < Wallaby::ResourcesController
    self.responder = Wallaby::JsonApiResponder
  end
end
