RSpec.configure do |config|
  config.before(type: :helper) do |example|
    next unless example.metadata[:prefixes]
    helper.lookup_context.prefixes = example.metadata[:prefixes]
  end
end
