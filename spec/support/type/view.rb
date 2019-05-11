RSpec.configure do |config|
  config.around :each, type: :view do |example|
    config.mock_with :rspec do |mocks|
      # NOTE: we turn this option off because it will complain
      # view does not implement dynamics methods such as named route paths
      mocks.verify_partial_doubles = false
      example.run
      mocks.verify_partial_doubles = true
    end
  end

  config.before :each, type: :view do |example|
    view.extend Wallaby::ApplicationHelper
    view.extend Wallaby::SecureHelper
    view.extend Wallaby::BaseHelper
    view.extend Wallaby::ResourcesHelper
    view.extend ActionView::Helpers::OutputSafetyHelper
    view.request.env['SCRIPT_NAME'] = example.metadata[:script_name] || '/admin'
    unless view.respond_to? :default_url_options
      def view.default_url_options
        @default_url_options ||= {}
      end
    end
  end
end
