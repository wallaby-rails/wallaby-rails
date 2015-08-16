require 'rails_helper'

describe Wallaby::ActiveRecordModelFinder do
  describe '#available_model_classes' do
    let(:all_model_classes) do
      class Airport < ActiveRecord::Base; end
      class Airline < ActiveRecord::Base; end
      class Airplane < ActiveRecord::Base; end
      [ Airport, Airline, Airplane ]
    end

    before do
      allow(ActiveRecord::Base).to receive(:subclasses).and_return(all_model_classes)
    end

    it 'returns a list of model class' do
      expect(subject.available_model_classes).to eq [ Airport, Airline, Airplane ]
    end
  end
end