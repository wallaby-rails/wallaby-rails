RSpec.configure do |config|
  config.before do
    Wallaby.configuration.clear
    Wallaby::Map.clear
  end

  config.around :suite do |example|
    Wallaby.configuration.clear
    Wallaby::Map.clear
    const_before = Object.constants
    example.run
    const_after = Object.constants
    Wallaby.configuration.clear
    Wallaby::Map.clear
    (const_after - const_before).each do |const|
      Object.send :remove_const, const
    end
  end
end
