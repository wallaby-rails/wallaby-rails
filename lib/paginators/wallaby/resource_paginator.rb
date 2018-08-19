module Wallaby
  # Resource paginator
  class ResourcePaginator < ModelPaginator
    abstract!

    def self.inherited(sub_class)
      warn I18n.t('deprecation.resource_paginator_inheirtance')
    end
  end
end
