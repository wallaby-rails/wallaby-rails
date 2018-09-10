module Wallaby
  # Resource paginator
  class ResourcePaginator < ModelPaginator
    abstract!

    def self.inherited(_sub_class)
      Utils.deprecate 'deprecation.resource_paginator_inheirtance', caller: caller
    end
  end
end
