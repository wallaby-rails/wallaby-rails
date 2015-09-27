require "wallaby/engine"

module Wallaby
  NAMESPACE = 'wallaby'

  def self.adaptor
    self::ActiveRecord
  end
end
