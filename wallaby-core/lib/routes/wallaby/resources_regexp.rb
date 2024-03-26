# frozen_string_literal: true

module Wallaby
  class ResourcesRegexp
    # This method works with {Map.id_regexp} to complete the constraint restriction in `config/routes.rb`.
    # This regular expression matches all the possible resources names that are loaded from the {.mode_map}
    #
    # It looks like `(products|orders|order/items|...)`
    def execute
      Regexp.new(<<~REGEXP, Regexp::EXTENDED)
        (#{resources_sources.join('|')}) # all the possible resources names
      REGEXP
    end

    protected

    def resources_sources
      # NOTE: `.reverse` is required so that for `order/items`,
      # `%r{order/items|order}` matches `order/items`, not `order`
      Map
        .mode_map
        .keys.flat_map { |klass| Inflector.to_resources_name(klass.to_s) }
        .sort.reverse.uniq
    end
  end
end
