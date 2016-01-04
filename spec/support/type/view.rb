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
end