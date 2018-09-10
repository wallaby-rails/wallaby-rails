module Wallaby
  # Resources controller, superclass for all customization controllers.
  # It contains CRUD template action methods (`index`/`new`/`create`/`edit`/`update`/`destroy`)
  # that allow subclasses to override.
  class ResourcesController < ::Wallaby::AbstractResourcesController
  end
end
