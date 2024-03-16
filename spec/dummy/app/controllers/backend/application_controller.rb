# frozen_string_literal: true

module Backend
  class ApplicationController < ::ApplicationController
    include Wallaby::View
    self.theme_name = 'secure'

    def prefixes
      render json: _prefixes
    end
  end
end
