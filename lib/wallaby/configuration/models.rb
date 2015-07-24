class Wallaby::Configuration::Models
  attr_accessor \
    :except,
    :only

  def initialize
    @except = []
    @only   = []
  end
end