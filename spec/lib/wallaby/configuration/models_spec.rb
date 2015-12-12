require 'rails_helper'

describe Wallaby::Configuration::Models do
  describe 'excludes' do
    it 'returns blank array by default' do
      expect(subject.excludes).to be_blank
      expect(subject.excludes).to be_a Array
    end

    it 'returns whatever has been assigned' do
      models = [ 'Model1', 'Model2' ]
      subject.exclude *models
      expect(subject.excludes).to eq models
    end
  end
end
