module Wallaby
  # Model Decorator interface
  class ModelDecorator
    attr_reader :model_class

    def initialize(model_class)
      @model_class = model_class
    end

    [EMPTY_STRING, 'index_', 'show_', 'form_'].each do |prefix|
      class_eval <<-RUBY
        def #{prefix}fields
          raise NotImplemented
        end

        def #{prefix}fields=(#{prefix}fields)
          @#{prefix}fields =
            ::ActiveSupport::HashWithIndifferentAccess.new #{prefix}fields
        end

        def #{prefix}field_names
          @#{prefix}field_names ||= #{prefix}fields.keys.tap do |names|
            names.delete primary_key
            names.unshift primary_key
          end
        end

        def #{prefix}field_names=(#{prefix}field_names)
          @#{prefix}field_names = #{prefix}field_names
        end

        def #{prefix}metadata_of(field_name)
          #{prefix}fields[field_name] || {}
        end

        def #{prefix}label_of(field_name)
          #{prefix}metadata_of(field_name)[:label]
        end

        def #{prefix}type_of(field_name)
          #{prefix}metadata_of(field_name)[:type]
        end
      RUBY
    end

    def filters
      @filters ||= ::ActiveSupport::HashWithIndifferentAccess.new
    end

    def form_active_errors(_resource)
      raise NotImplemented
    end

    def primary_key
      raise NotImplemented
    end

    def guess_title(_resource)
      raise NotImplemented
    end

    def resources_name
      Map.resources_name_map @model_class
    end
  end
end
