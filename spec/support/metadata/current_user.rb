RSpec.configure do |config|
  config.before do |example|
    if example.metadata.has_key? :current_user
      allow(controller).to receive(:current_user) { example.metadata[:current_user] }
    end
  end
end
