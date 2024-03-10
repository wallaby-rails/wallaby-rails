# frozen_string_literal: true

module Wallaby
  # Base class to find out the class for given {#script_name}, {#model_class}, {#current_controller_class}
  class ClassFinder
    include ActiveModel::Model

    # @!attribute script_name
    # @return [String]
    attr_accessor :script_name
    # @!attribute model_class
    # @return [Class]
    attr_accessor :model_class
    # @!attribute current_controller_class
    # @return [Class]
    attr_accessor :current_controller_class

    protected

    # @return [Class]
    def possible_default_class
      Guesser.possible_class_from(possible_class_name, denamespace: denamespace?)
    end

    # @return [String] class name
    def possible_class_name
      @possible_class_name ||= Inflector.try(:"to_#{type}_name", script_name, model_class)
    end

    # This attribute will determine if the {#possible_default_class}
    # should keep removing the namespaces one by one when looking up the class
    # @return [Boolean]
    def denamespace?
      true
    end

    # @return [String] type for the finder
    def type
      self.class.name.demodulize.sub(FINDER, EMPTY_STRING).underscore
    end
  end
end
