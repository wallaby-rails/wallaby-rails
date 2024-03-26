# frozen_string_literal: true

module Wallaby
  # This is designed to delegate all the methods to {#lazy_regexp}
  # So that it doesn't need to load all the models for {Map.mode_map}
  # when the engine is mounted in `config/routes.rb`
  #
  # @see Map.resources_regexp
  # @see Map.id_regexp
  class LazyRegexp < Regexp
    delegate(*Regexp.instance_methods(false), to: :lazy_regexp)

    def initialize(source, **options)
      @lazy_source = source
      super(source.to_s, **options)
    end

    protected

    def lazy_regexp
      Map.try(@lazy_source)
    end
  end
end
