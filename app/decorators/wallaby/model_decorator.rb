class Wallaby::ModelDecorator
  attr_reader :model_class
  delegate :to_s, to: :model_class

  def initialize model_class
    @model_class = model_class
  end

  def primary_key
    raise Wallaby::NotImplemented
  end

  def collection
    raise Wallaby::NotImplemented
  end

  def find_or_initialize id
    raise Wallaby::NotImplemented
  end

  def guess_label resource
    raise Wallaby::NotImplemented
  end

  [ '', 'index_', 'show_', 'form_' ].each do |prefix|
    class_eval <<-RUBY
      def #{ prefix }field_names
        raise Wallaby::NotImplemented
      end

      def #{ prefix }field_labels
        raise Wallaby::NotImplemented
      end

      def #{ prefix }field_types
        raise Wallaby::NotImplemented
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