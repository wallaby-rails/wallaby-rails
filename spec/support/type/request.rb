module Wallaby
  module RSpec
    module RequestSupport
      def http(verb, url, hash = {})
        if Rails::VERSION::MAJOR == 4
          send verb, url, hash[:params], hash[:headers]
        else
          send verb, url, hash
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include Wallaby::RSpec::RequestSupport, type: :request
end
