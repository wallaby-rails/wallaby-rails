RSpec.configure do |config|
  config.around do |example|
    ObjectSpace.garbage_collect if example.metadata[:clear] == :object_space
    example.run
    ObjectSpace.garbage_collect if example.metadata[:clear] == :object_space
  end
end
