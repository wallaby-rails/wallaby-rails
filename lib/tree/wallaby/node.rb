module Wallaby
  # Node to present tree structure
  class Node
    attr_reader :klass
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
