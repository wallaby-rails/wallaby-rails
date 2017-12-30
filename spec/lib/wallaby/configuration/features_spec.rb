require 'rails_helper'

describe Wallaby::Configuration::Features do
  describe '#turbolinks_enabled' do
    it 'returns turbolinks_enabled' do
      expect(subject.turbolinks_enabled).to be_falsy
      subject.turbolinks_enabled = true
      expect(subject.turbolinks_enabled).to be_truthy
    end
  end
end
