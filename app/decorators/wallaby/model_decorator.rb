class Wallaby::ModelDecorator
  attr_reader :model_class

  def initialize(model_class)
    @model_class = model_class
  end

  def collection(params = {})
    fail Wallaby::NotImplemented
  end

  def search(params = {})
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

      def #{ prefix }field_names
        @#{ prefix }field_names ||= #{ prefix }fields.keys.tap do |names|
          names.delete primary_key
          names.unshift primary_key
        end
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

  def form_require_name
    fail Wallaby::NotImplemented
  end

  def form_strong_param_names
    fail Wallaby::NotImplemented
  end

  def primary_key
    fail Wallaby::NotImplemented
  end

  def guess_title(resource)
    fail Wallaby::NotImplemented
  end

  def model_label
    Wallaby::Utils.to_model_label @model_class
  end

  def resources_name
    Wallaby::Utils.to_resources_name @model_class
  end
end