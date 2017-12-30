module Versions
  def minor(results, other = nil)
    results[Rails::VERSION::MAJOR].try(:[], Rails::VERSION::MINOR) || other
  end

  def tiny(results, other = nil)
    results[Rails::VERSION::MAJOR].try(:[], Rails::VERSION::MINOR).try(:[], Rails::VERSION::TINY) || other
  end
end

RSpec.configure do |config|
  config.include Versions
end
