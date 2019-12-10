RSpec.configure do |config|
  config.before(type: :helper) do |example|
    next unless example.metadata[:prefixes]

    view.lookup_context.prefixes = helper.view_renderer.lookup_context.prefixes = example.metadata[:prefixes]
  end
end
