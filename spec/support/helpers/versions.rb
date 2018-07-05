module Versions
  def minor(results, other = nil)
    results[Rails::VERSION::MAJOR].try(:[], Rails::VERSION::MINOR) || other
  end

  def tiny(results, other = nil)
    results[Rails::VERSION::MAJOR].try(:[], Rails::VERSION::MINOR).try(:[], Rails::VERSION::TINY) || other
  end

  def version?(string)
    operator = string[/\<|\<\=|\=\>|\>|\~\>/]
    _, major, minor, tiny = string.match(/(\d+)\.?(\d+)?\.?(\d+)?/).to_a
    operator = '==' if operator.blank?
    check_version operator, major, minor, tiny
  end

  def check_version(operator, major, minor, tiny)
    if operator == '~>'
      Rails::VERSION::MAJOR == major.to_i && Rails::VERSION::MINOR == minor.to_i
    else
      Rails::VERSION::MAJOR.public_send(operator, major.to_i) \
        && Rails::VERSION::MINOR.public_send(operator, minor.to_i) \
        && Rails::VERSION::TINY.public_send(operator, tiny.to_i)
    end
  end
end

RSpec.configure do |config|
  config.include Versions
end
