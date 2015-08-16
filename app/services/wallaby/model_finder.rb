class Wallaby::ModelFinder
  def available_model_classes
    # TODO: filters the model classes using Wallaby.configuration
    all
  end

  protected
  def all
    raise Wallaby::NotImplemented
  end
end