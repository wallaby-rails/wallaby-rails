require 'rails_helper'

describe Wallaby::ActiveRecord::ModelFinder do
  describe '#all' do
    let(:valid_model_classes) do
      class Airport < ActiveRecord::Base; end
      class Airline < ActiveRecord::Base; end
      class Airplane < ActiveRecord::Base; end
      [ Airport, Airline, Airplane ]
    end

    let(:anonymous_class) do
      Class.new ActiveRecord::Base
    end

    before do
      allow(ActiveRecord::Base).to receive(:subclasses).and_return(valid_model_classes + [ anonymous_class ])
    end

    it 'excludes anonymous_class' do
      expect(subject.send :all).to eq valid_model_classes
    end
  end
end