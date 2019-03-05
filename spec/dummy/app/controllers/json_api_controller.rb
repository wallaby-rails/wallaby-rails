class JsonApiController < Wallaby::ResourcesController
  self.base_class!
  self.responder = Wallaby::JsonApiResponder
end
