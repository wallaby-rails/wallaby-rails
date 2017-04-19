module Wallaby
  # Model Decorator interface
  class ModelDecorator
    attr_reader :model_class

    def initialize(model_class)
      @model_class = model_class
    end

    ['', 'index_', 'show_', 'form_'].each do |prefix|
      class_eval <<-RUBY
        def #{prefix}fields
          raise Wallaby::NotImplemented
        end

        def #{prefix}fields=(#{prefix}fields)
          @#{prefix}fields = #{prefix}fields.with_indifferent_access
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

    def form_active_errors(_resource)
      raise Wallaby::NotImplemented
    end

    def primary_key
      raise Wallaby::NotImplemented
    end

    def guess_title(_resource)
      raise Wallaby::NotImplemented
    end

    def resources_name
      Wallaby::Utils.to_resources_name @model_class
    end
  end
end
