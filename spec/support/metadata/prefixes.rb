RSpec.configure do |config|
  config.before(type: :helper) do |example|
    if example.metadata[:prefixes]
      lookup_context = Wallaby::LookupContextWrapper.new helper.view_renderer.lookup_context
      helper.view_renderer.lookup_context = lookup_context

      allow(lookup_context).to receive(:prefixes) { example.metadata[:prefixes] }
    end
  end
end
