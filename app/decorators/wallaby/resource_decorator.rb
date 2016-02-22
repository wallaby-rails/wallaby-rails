class Wallaby::ResourceDecorator
  class << self
    def model_class
      if self < Wallaby::ResourceDecorator
        @model_class ||= name.gsub('Decorator', '').constantize
      end
    end

    def model_decorator(model_class = self.model_class)
      model_decorator_class = Wallaby.configuration.adaptor.model_decorator
      if self < Wallaby::ResourceDecorator
        @model_decorator ||= model_decorator_class.new model_class
      else
        model_decorator_class.new model_class if model_class
      end
    end

    template_methods = Wallaby::ModelDecorator.instance_methods - Object.instance_methods - %i( model_class )

    delegate *template_methods, to: :model_decorator, allow_nil: true

    def decorate(resource)
      return resource if resource.is_a? Wallaby::ResourceDecorator
      new resource
    end
  end

  def initialize(resource)
    @resource         = resource
    @model_decorator  = self.class.model_decorator model_class

    if self.class < Wallaby::ResourceDecorator
      [ '', 'index_', 'show_', 'form_' ].each do |prefix|
        send "#{ prefix }field_names"
        send "#{ prefix }fields"
      end
    end
  end

  def method_missing(method_id, *args)
    if resource.respond_to? method_id
      resource.send method_id, *args
    else
      super
    end
  end

  attr_accessor :resource, :model_decorator
  delegate :to_s, :to_param, :to_params, to: :resource

  def model_class
    @resource.class
  end

  def to_label
    model_decorator.guess_title resource
  end

  def errors
    model_decorator.form_errors(resource).with_indifferent_access
  end

  def resources_name
    Wallaby::Utils.to_resources_name model_class.to_s
  end

  [ '', 'index_', 'show_', 'form_' ].each do |prefix|
    class_eval <<-RUBY
      def #{ prefix }fields
        @#{ prefix }fields ||= model_decorator.#{ prefix }fields.dup.freeze
      end

      def #{ prefix }field_names
        @#{ prefix }field_names ||= model_decorator.#{ prefix }field_names.dup.freeze
      end
    RUBY

    template_methods = %w( metadata_of label_of type_of ).map { |method_id| "#{ prefix }#{ method_id }" }
    delegate *template_methods, to: :model_decorator
  end

  template_methods = (Wallaby::ModelDecorator.instance_methods - Object.instance_methods).reject { |method_id| %r(model_class|fields|field_names) =~ method_id.to_s }

  delegate *template_methods, to: :model_decorator
end
