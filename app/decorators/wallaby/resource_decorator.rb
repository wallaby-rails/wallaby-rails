class Wallaby::ResourceDecorator
  class << self
    def model_class
      if self < Wallaby::ResourceDecorator
        @model_class ||= name.gsub('Decorator', '').constantize
      end
    end

    def model_decorator model = nil
      if self < Wallaby::ResourceDecorator
        @model_decorator ||= build_model_decorator model
      else
        build_model_decorator model
      end
    end

    def build_model_decorator model
      model ||= self.model_class
      Wallaby.adaptor.model_decorator.new model if model
    end


    [ '', 'index_', 'show_', 'form_' ].each do |prefix|
      class_eval <<-RUBY
        def #{ prefix }field_names
          model_decorator.try :#{ prefix }field_names
        end

        def #{ prefix }field_labels
          model_decorator.try :#{ prefix }field_labels
        end

        def #{ prefix }field_types
          model_decorator.try :#{ prefix }field_types
        end

        def #{ prefix }label_of field_name
          #{ prefix }field_labels.try :[], field_name
        end

        def #{ prefix }type_of field_name
          #{ prefix }field_types.try :[], field_name
        end
      RUBY
    end
  end

  def initialize resource
    @resource         = resource
    @model_decorator  = self.class.model_decorator model_class
  end

  attr_accessor :resource, :model_decorator

  def model_class
    @resource.class
  end

  [ '', 'index_', 'show_', 'form_' ].each do |prefix|
    class_eval <<-RUBY
      def #{ prefix }field_names
        @#{ prefix }field_names ||= model_decorator.#{ prefix }field_names.dup.freeze
      end

      def #{ prefix }field_labels
        @#{ prefix }field_labels ||= model_decorator.#{ prefix }field_labels.dup.freeze
      end

      def #{ prefix }field_types
        @#{ prefix }field_types ||= model_decorator.#{ prefix }field_types.dup.freeze
      end

      def #{ prefix }label_of field_name
        #{ prefix }field_labels[field_name]
      end

      def #{ prefix }type_of field_name
        #{ prefix }field_types[field_name]
      end
    RUBY
  end
end