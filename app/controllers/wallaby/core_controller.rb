module Wallaby
  class CoreController < SecureController
    include CoreMethods
    helper 'wallaby/styling'
    helper 'wallaby/links'

    before_action :authenticate_user!, except: [ :status ]

    def status
      render text: 'healthy'
    end
  end
end
