module Versions
  def minor(results, other = nil)
    results[Rails::VERSION::MAJOR].try(:[], Rails::VERSION::MINOR) || tiny(results, other)
  end

  def tiny(results, other = nil)
    results[Rails::VERSION::MAJOR].try(:[], Rails::VERSION::MINOR).try(:[], Rails::VERSION::TINY) || results.find { |ver, _| version? ver.to_s }.try(:last) || other || {}
  end

  def version?(string)
    operator = string[/\<|\<\=|\=\>|\>|\~\>/]
    _, major, minor, tiny = string.match(/(\d+)\.?(\d+)?\.?(\d+)?/).to_a.map(&:to_i)
    operator = '==' if operator.blank?
    check_version operator, major, minor, tiny
  end

  def check_version(operator, major, minor, tiny)
    if operator == '~>'
      Rails::VERSION::MAJOR == major && Rails::VERSION::MINOR == minor
    else
      v1 = Gem::Version.new(Rails::VERSION::STRING)
      v2 = Gem::Version.new([major, minor, tiny].compact.join('.'))
      v1.public_send(operator, v2)
    end
  end
end

RSpec.configure do |config|
  config.include Versions
end
