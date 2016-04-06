module Parameters
  def parameters(hash)
    ActionController::Parameters.new hash
  end
end

RSpec.configure do |config|
  config.include Parameters
end
