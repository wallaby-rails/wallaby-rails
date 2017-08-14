module Wallaby
  class NilModelDecorator < ModelDecorator
    def guess_title(resource)
      resource
    end
  end
end
