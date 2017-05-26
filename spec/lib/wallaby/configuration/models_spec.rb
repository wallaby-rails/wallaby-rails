require 'rails_helper'

describe Wallaby::Configuration::Models do
  describe '#set' do
    it 'sets the models' do
      expect(subject.set(AllPostgresType)).to eq [AllPostgresType]
      expect(subject.set([AllPostgresType])).to eq [AllPostgresType]
    end
  end

  describe '#presence' do
    it 'returns presence of models' do
      expect(subject.presence).to be_nil
      subject.set AllPostgresType
      expect(subject.presence).to eq [AllPostgresType]
    end
  end

  describe 'excludes' do
    it 'returns blank array by default' do
      expect(subject.excludes).to be_blank
      expect(subject.excludes).to be_a Array
    end

    it 'returns whatever has been assigned' do
      models = %w[Model1 Model2]
      subject.exclude(*models)
      expect(subject.excludes).to eq models
    end
  end
end
