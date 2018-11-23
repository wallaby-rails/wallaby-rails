module Wallaby
  # To present classes in tree structure.
  class Node
    # @!attribute [r] klass
    # Represent the current class
    attr_reader :klass
    # @!attribute parent
    # Represent the parent class of current class
    attr_accessor :parent

    delegate :name, to: :klass

    # @param klass [Class]
    def initialize(klass)
      @klass = klass
    end

    # @return [Array<Class>] a list of children classes
    def children
      @children ||= []
    end
  end
end
