# frozen_string_literal: true

module Wallaby
  # (see #execute)
  class PaginatorFinder < ServicerFinder
    # Find paginator class by script name and model class from the following places:
    #
    # - {#current_controller_class #current_controller_class}'s
    #   {Configurable::ClassMethods#model_paginator #model_paginator}
    # - possible paginator class built from script name and model class,
    #   e.g. **/admin** and **Order::Item** will give us the possible paginators:
    #   - Admin::Order::ItemPaginator
    #   - Order::ItemPaginator
    #   - ItemPaginator
    # - {#current_controller_class #current_controller_class}'s default
    #   {Configurable::ClassMethods#application_paginator #application_paginator}
    # @return [Class] paginator class
    def execute
      current_controller_class.model_paginator ||
        possible_default_class ||
        current_controller_class.application_paginator
    end
  end
end
