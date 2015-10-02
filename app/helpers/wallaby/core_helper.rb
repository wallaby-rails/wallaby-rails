module Wallaby::CoreHelper
  def link_to_model model
    decorator = model_decorator model
    name      = Wallaby::Utils.to_resources_name model.to_s
    # link_to decorator.model_label, wallaby_engine.resources_path(name)
  end
end