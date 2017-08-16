module Wallaby
  # nil model decorator to take care something that can't be handled
  class NilModelDecorator < ModelDecorator
    def guess_title(resource)
      resource
    end
  end
end
