module Wallaby
  class ApplicationController < ::ApplicationController
    begin # error handling methods
      def not_found exception = nil
        render text: 'Not found', status: 404
      end
    end
  end
end