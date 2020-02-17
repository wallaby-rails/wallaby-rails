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

  config.before :each, type: :helper do |example|
    view.extend Wallaby::ApplicationHelper
    view.extend Wallaby::SecureHelper
    view.extend Wallaby::BaseHelper
    view.extend Wallaby::ResourcesHelper
    view.request.env['SCRIPT_NAME'] = example.metadata[:script_name] || '/admin'
    helper.output_buffer = ''

    if view.respond_to? :default_url_options
      view.default_url_options = { only_path: true, host: 'test.host' }
    else
      def view.default_url_options
        @default_url_options ||= { only_path: true, host: 'test.host' }
      end
    end
  end
end
