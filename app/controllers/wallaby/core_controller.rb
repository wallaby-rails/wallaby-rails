module Wallaby
  class CoreController < SecureController
    def status
      render text: 'ok'
    end

    begin # global callbacks
    end

    before_action :build_up_view_paths

    protected
    def build_up_view_paths
      Wallaby::Services::PrefixesBuilder.new(self).rebuild
    end
  end
end