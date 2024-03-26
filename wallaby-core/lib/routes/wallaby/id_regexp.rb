# frozen_string_literal: true

module Wallaby
  class IdRegexp < ResourcesRegexp
    # This method works with {Map.resources_regexp} to complete the constraint restriction in `config/routes.rb`.
    # This regular expression matches the ids which have all the possible resources names in front
    #
    # It looks like `((?<=products/)|(?<=orders/)|(?<=order/items/)|...|(?<!.))[^/]+`:
    #
    # - `(?<=products/)` is a positive lookbehind assertion,
    #   it means the ids must have `products/` in front of itself, but the match data won't include `products/`.
    #   it matches string e.g. `/admin/products/1`, and the match data is `1`.
    # - `(?<!.)` is a negative lookbehind assertion,
    #   it means the ids must have nothing in front of itself.
    #   it matches string e.g. `1`, and the match data is `1`.
    #   this is required for URL helper when `:id` param is given,
    #   e.g. `resources_path(action: 'show', resources: 'products', id: 1)`
    # - `[^/]+` is to match id. id can be anything as long as it doesn't contain `|` character.
    def execute
      Regexp.new(<<~REGEXP, Regexp::EXTENDED)
        (
          #{resources_sources.map { |resources| "(?<=#{resources}/)" }.join('|')} # all the possible resources names in front of the id
          |(?<!.) # nothing is in front of the id, this is needed by URL helpers
        )
        [^/]+ # id
      REGEXP
    end
  end
end
