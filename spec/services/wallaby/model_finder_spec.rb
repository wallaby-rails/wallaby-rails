require 'rails_helper'

describe Wallaby::ModelFinder do
  describe '#all' do
    it 'raises not implemented error' do
      expect{ subject.send :all }.to raise_error Wallaby::NotImplemented
    end
  end

  describe '#available' do
    let(:model_class) do
      Class.new ActiveRecord::Base do
        def self.name
          'Product'
        end
      end
    end

    it 'returns available models' do
      allow(subject).to receive(:all).and_return([ model_class ])
      expect(Wallaby.configuration.models.excludes).to be_blank
      expect(subject.available).to eq [ model_class ]

      Wallaby.configuration.models.excludes << model_class
      expect(subject.available).to be_blank

      Wallaby.configuration.models.excludes.delete model_class
    end
  end
end