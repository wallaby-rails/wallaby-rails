class Wallaby::ModelDecorator
  attr_reader :model_class

  def initialize(model_class)
    @model_class = model_class
  end

  def collection(params = {})
    fail Wallaby::NotImplemented
  end

  def find_or_initialize(id = nil)
    fail Wallaby::NotImplemented
  end

  [ '', 'index_', 'show_', 'form_' ].each do |prefix|
    class_eval <<-RUBY
      def #{ prefix }fields
        fail Wallaby::NotImplemented
      end

      def #{ prefix }fields=(#{ prefix }fields)
        @#{ prefix }fields = #{ prefix }fields
      end

      def #{ prefix }field_names
        @#{ prefix }field_names ||= #{ prefix }fields.keys.tap do |names|
          names.delete primary_key
          names.unshift primary_key
        end
      end

      def #{ prefix }field_names=(#{ prefix }field_names)
        @#{ prefix }field_names = #{ prefix }field_names
      end

      def #{ prefix }metadata_of(field_name)
        #{ prefix }fields[field_name] || {}
      end

      def #{ prefix }label_of(field_name)
        #{ prefix }metadata_of(field_name)[:label]
      end

      def #{ prefix }type_of(field_name)
        #{ prefix }metadata_of(field_name)[:type]
      end
    RUBY
  end

  def param_key
    fail Wallaby::NotImplemented
  end

  def form_strong_param_names
    fail Wallaby::NotImplemented
  end

  def form_active_errors(resource)
    fail Wallaby::NotImplemented
  end

  def primary_key
    fail Wallaby::NotImplemented
  end

  def guess_title(resource)
    fail Wallaby::NotImplemented
  end

  def resources_name
    Wallaby::Utils.to_resources_name @model_class
  end
end
