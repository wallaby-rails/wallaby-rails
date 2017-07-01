module Parameters
  def parameters(hash = {})
    ActionController::Parameters.new hash
  end

  def parameters!(hash = {})
    ActionController::Parameters.new(hash).permit!
  end
end

RSpec.configure do |config|
  config.include Parameters
end
