# frozen_string_literal: true

module HelperSupport
  def url_options
    # NOTE: make it possible to change the url_options from controller
    # as super is a frozen object
    @url_options ||= super.dup
  end
end

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
    view.extend Wallaby::ResourcesHelper
    view.instance_variable_set(:@wallaby_controller, example.metadata[:wallaby_controller] || Wallaby::ResourcesController)
    view.request.env['SCRIPT_NAME'] = example.metadata[:script_name] || '/admin'
    helper.output_buffer = ActionView::OutputBuffer.new
    helper.extend HelperSupport
  end

  # custom default_url_options
  config.before :each, type: :helper do |example|
    custom_default_url_options =
      {
        only_path: true, # no url helper will be tested
        host: 'www.example.com'
      }.merge(example.metadata[:default_url_options] || {})

    allow(view)
      .to receive(:default_url_options)
      .and_return(custom_default_url_options)
  end

  # custom model_class
  config.before :each, type: :helper do |example|
    next if example.metadata[:model_class].blank?

    allow(view)
      .to receive(:model_class)
      .and_return(example.metadata[:model_class])
  end

  # custom current_model_class
  config.before :each, type: :helper do |example|
    next if example.metadata[:current_model_class].blank?

    allow(view)
      .to receive(:current_model_class)
      .and_return(example.metadata[:current_model_class])
  end

  config.after :each, type: :helper do |_example|
    view.instance_variable_get(:@wallaby_controller).clear
  end
end
