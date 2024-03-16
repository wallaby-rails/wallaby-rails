# frozen_string_literal: true

module ClassesHelper
  def base_class_from(base = Class)
    Class.new(base) do
      base_class!
      yield if block_given?
    end
  end
end

RSpec.configure do |config|
  config.include ClassesHelper
end
