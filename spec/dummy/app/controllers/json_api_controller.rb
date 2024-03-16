# frozen_string_literal: true

class JsonApiController < Wallaby::ResourcesController
  base_class!
  self.responder = Wallaby::JsonApiResponder
end
