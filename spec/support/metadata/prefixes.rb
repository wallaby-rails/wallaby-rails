RSpec.configure do |config|
  config.before(type: :helper) do |example|
    helper.view_renderer.lookup_context = Wallaby::CustomLookupContext.new(
      helper.view_paths, {}, helper.lookup_context.prefixes
    )
    next unless example.metadata[:prefixes]
    helper.lookup_context.prefixes = example.metadata[:prefixes]
  end
end
