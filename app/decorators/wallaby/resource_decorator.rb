class Wallaby::ResourceDecorator
  class << self
    def model_class
      if self < Wallaby::ResourceDecorator
        @model_class ||= name.gsub('Decorator', '').constantize
      end
    end

    def model_decorator
      if self < Wallaby::ResourceDecorator
        @model_decorator ||= Wallaby.adaptor.model_decorator.new model_class
      end
    end

    def decorate(resource)
      return resource if resource.is_a? Wallaby::ResourceDecorator
      new resource
    end

    delegate *begin
      Wallaby::ModelDecorator.instance_methods \
        - Object.instance_methods - %i( model_class )
    end, to: :model_decorator, allow_nil: true
  end

  def initialize(resource)
    @resource         = resource
    @model_decorator  = self.class.model_decorator ||
                        Wallaby.adaptor.model_decorator.new(model_class)
  end

  def method_missing(method_id, *args)
    if @resource.respond_to? method_id
      @resource.send method_id, *args
    else
      super
    end
  end

  delegate :to_s, :to_param, :to_params, to: :@resource
  delegate *begin
    Wallaby::ModelDecorator.instance_methods.reject{ |m| %r((index_|show_|form_)?(fields|field_names)) =~ m.to_s } - Object.instance_methods
  end, to: :@model_decorator
  attr_reader :model_decorator

  def model_class
    @resource.class
  end

  def resource
    @resource
  end

  def to_label
    @model_decorator.guess_title(@resource) || primary_key_value
  end

  def errors
    @model_decorator.form_active_errors(@resource)
  end

  def primary_key_value
    @resource.send primary_key
  end

  [ '', 'index_', 'show_', 'form_' ].each do |prefix|
    class_eval <<-RUBY
      def #{ prefix }fields
        @#{ prefix }fields ||= @model_decorator.#{ prefix }fields.dup.freeze
      end

      def #{ prefix }field_names
        @#{ prefix }field_names ||= @model_decorator.#{ prefix }field_names.dup.freeze
      end
    RUBY
  end
end
