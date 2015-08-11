module Wallaby::Decorator::ClassMethods
  extend ActiveSupport::Concern

  included do
    class << self
      attr_writer \
        :model_class,
        :model_name,
        :fields,
        :list_fields,
        :show_fields,
        :new_fields,
        :edit_fields
    end
  end

  class_methods do
    def build model, record = nil
      raise ArgumentError unless model
      decorator = subclasses.find do |klass|
        klass.name == "#{ model.name }Decorator" ||
        klass.model_class.name == model.name
      end
      if decorator
        decorator.new record
      else
        new record, model
      end
    end

    def model_class
      @model_class ||= Wallaby::Services.class_finder.find(name.gsub %r{(Wallaby::)?Decorator}i, '')
    end

    def model_name
      @model_name ||= model_class.try do |klass|
        klass.model_name
      end
    end

    def fields
      @fields ||= model_class.try(:column_names) || []
    end

    def list_fields
      @list_fields ||= fields.try(:dup) || []
    end

    def show_fields
      @show_fields ||= fields.try(:dup) || []
    end

    def new_fields
      @new_fields ||= model_class.try do |klass|
        klass.columns.select do |column|
          ![ model_class.primary_key, 'updated_at', 'created_at' ].include? column.name
        end.map(&:name)
      end || []
    end

    def edit_fields
      @edit_fields ||= new_fields.try(:dup) || []
    end
  end
end