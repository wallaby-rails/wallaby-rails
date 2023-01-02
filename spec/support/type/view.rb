# frozen_string_literal: true
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
    view.extend Wallaby::ResourcesHelper
    view.instance_variable_set('@wallaby_controller', example.metadata[:wallaby_controller] || Wallaby::ResourcesController)
    view.request.env['SCRIPT_NAME'] = example.metadata[:script_name] || '/admin/products'

    if view.respond_to? :default_url_options
      view.default_url_options = { only_path: true, host: 'www.example.com' }
    else
      def view.default_url_options
        @default_url_options ||= { only_path: true, host: 'www.example.com' }
      end
    end

    unless controller.respond_to? :current_user
      controller.instance_variable_set('@current_user', example.metadata[:current_user])
      def controller.current_user # rubocop:disable Style/TrivialAccessors
        @current_user
      end
    end
  end

  config.after :each, type: :view do |_example|
    view.instance_variable_get('@wallaby_controller').clear
  end
end
