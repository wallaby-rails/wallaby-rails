require 'rails_helper'

describe Wallaby::ActiveRecord::ModelFinder do
  describe '#all' do
    before do
      class Airport; def self.abstract_class?; false; end; end
      class Airline; def self.abstract_class?; false; end; end
      class Airplane; def self.abstract_class?; false; end; end
      class Airplane::HABTM_Airports; def self.abstract_class?; false; end; end
      class AbstractAirport; def self.abstract_class?; true; end; end
      Rails.cache.delete 'wallaby/model_finder'
    end

    it 'returns valid model classes in alphabetic order' do
      allow(ActiveRecord::Base).to receive(:subclasses).and_return [ Airport, Airplane, Airline ]
      expect(subject.send :all).to eq [ Airline, Airplane, Airport ]
    end

    context 'when there is abstract class' do
      it 'filters out abstract class' do
        allow(ActiveRecord::Base).to receive(:subclasses).and_return [ AbstractAirport ]
        expect(subject.send :all).to be_blank
      end
    end

    context 'when there is HABTM class' do
      it 'filters out HABTM class' do
        allow(ActiveRecord::Base).to receive(:subclasses).and_return [ Airplane::HABTM_Airports ]
        expect(subject.send :all).to be_blank
      end
    end

    context 'when there is anonymous class' do
      it 'filters out anonymous class' do
        anonymous_class = Class.new do
          def self.abstract_class?
            false
          end
        end
        allow(ActiveRecord::Base).to receive(:subclasses).and_return [ anonymous_class ]
        expect(subject.send :all).to be_blank
      end
    end
  end
end
