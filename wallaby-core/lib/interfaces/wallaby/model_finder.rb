# frozen_string_literal: true

module Wallaby
  # see {#all}
  class ModelFinder
    # @note Template method to return all the available models for a {Mode}
    # @return [Array<Class>] a list of model classes
    def all
      raise NotImplemented
    end
  end
end
