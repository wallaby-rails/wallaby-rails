RSpec.configure do |config|
  config.around :each, type: :helper do |example|
    config.mock_with :rspec do |mocks|
      # NOTE: we turn this option off because it will complain
      # helper does not implement dynamics methods such as named route paths
      mocks.verify_partial_doubles = false
      example.run
      mocks.verify_partial_doubles = true
    end
  end

  config.before :each, type: :helper do
    view.extend Wallaby::ApplicationHelper
    view.extend Wallaby::SecureHelper
    view.extend Wallaby::BaseHelper
    view.extend Wallaby::ResourcesHelper
    helper.output_buffer = ''
  end
end
