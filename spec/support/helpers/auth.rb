# frozen_string_literal: true

module AuthHelper
  def cancancan_context(ability)
    Struct.new(:current_ability).new(ability)
  end

  def cancancan_authorzier(ability, model_class)
    Wallaby::ModelAuthorizer.create cancancan_context(ability), model_class
  end
end

RSpec.configure do |config|
  config.include AuthHelper
end
