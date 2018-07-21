require 'rails_helper'

describe Wallaby::EngineNameFinder, clear: :object_space do
  describe '.find' do
    # @see spec/dummy/config/routes.rb
    it 'returns the name/alias of an engine' do
      expect(described_class.find('SCRIPT_NAME' => '')).to eq ''
      expect(described_class.find('SCRIPT_NAME' => '/admin')).to eq 'wallaby_engine'
      expect(described_class.find('SCRIPT_NAME' => '/admin_else')).to eq 'manager_engine'
      expect(described_class.find('SCRIPT_NAME' => '/core/admin')).to eq 'core_nested_engine'
      expect(described_class.find('SCRIPT_NAME' => '/main/admin')).to eq 'main_engine'
    end
  end
end
