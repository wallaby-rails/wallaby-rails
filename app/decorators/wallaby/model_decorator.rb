class Wallaby::ModelDecorator
  METHODS_TO_IMPLEMENT = %w(
    list_field_names
    label_of
    to_param
    to_s
  )
  def initialize model_class
    @model_class = model_class
  end

  delegate *METHODS_TO_IMPLEMENT, to: :adaptor

  protected
  def adaptor
    @adaptor ||= Wallaby.configuration.model_decorator.new(@model_class)
  end
end