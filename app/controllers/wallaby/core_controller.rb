module Wallaby
  class CoreController < SecureController
    def status
      render text: 'ok'
    end

    begin # global callbacks
    end
  end
end