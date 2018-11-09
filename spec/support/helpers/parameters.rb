module Parameters
  def parameters(hash = {})
    ActionController::Parameters.new hash
  end

  def parameters!(hash = {})
    ActionController::Parameters.new(hash).permit!
  end

  def spec_params(hash)
    Rails::VERSION::MAJOR >= 5 ? { params: hash } : hash
  end
end

RSpec.configure do |config|
  config.include Parameters
end
