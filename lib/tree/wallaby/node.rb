module Wallaby
  # Node to present tree structure
  class Node
    attr_reader :klass
    attr_accessor :parent

    delegate :name, to: :klass

    def initialize(klass)
      @klass = klass
    end

    def children
      @children ||= []
    end
  end
end
