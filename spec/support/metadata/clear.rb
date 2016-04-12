RSpec.configure do |config|
  config.before do |example|
    ObjectSpace.garbage_collect if example.metadata[:clear] == :object_space
  end
end
