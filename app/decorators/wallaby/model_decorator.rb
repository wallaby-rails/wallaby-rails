class Wallaby::ModelDecorator
  def initialize model_class
    @model_class = model_class
  end

  def model_label
    Wallaby::Utils.to_model_label @model_class
  end

  def primary_key
    raise Wallaby::NotImplemented
  end

  def collection params = {}
    raise Wallaby::NotImplemented
  end

  def find_or_initialize id
    raise Wallaby::NotImplemented
  end

  def guess_title resource
    raise Wallaby::NotImplemented
  end

  [ '', 'index_', 'show_', 'form_' ].each do |prefix|
    class_eval <<-RUBY
      def #{ prefix }fields
        raise Wallaby::NotImplemented
      end

      def #{ prefix }field_names
        @#{ prefix }field_names ||= #{ prefix }fields.keys.tap do |names|
          names.unshift primary_key
        end.uniq
      end

      def #{ prefix }metadata_of field_name
        #{ prefix }fields[field_name] || {}
      end

      def #{ prefix }label_of field_name
        #{ prefix }metadata_of(field_name)[:label]
      end

      def #{ prefix }type_of field_name
        #{ prefix }metadata_of(field_name)[:type]
      end
    RUBY
  end
end