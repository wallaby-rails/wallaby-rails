# frozen_string_literal: true

module Wallaby
  class Custom
    # Default authorization provider for {Custom} mode that allowlists everything.
    class DefaultProvider < DefaultAuthorizationProvider
    end
  end
end
