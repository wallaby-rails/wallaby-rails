require 'rails_helper'

describe Wallaby::ActiveRecord::ModelFinder, clear: :object_space do
  describe '#all' do
    before do
      stub_const 'Airport', (Class.new { def self.abstract_class?; false; end })
      stub_const 'Airline', (Class.new { def self.abstract_class?; false; end })
      stub_const 'Airplane', (Class.new { def self.abstract_class?; false; end })
      stub_const 'Airplane::HABTM_Airports', (Class.new { def self.abstract_class?; false; end })
      stub_const 'AbstractAirport', (Class.new { def self.abstract_class?; true; end })
    end

    it 'returns valid model classes in alphabetic order' do
      allow(ActiveRecord::Base).to receive(:descendants).and_return [ Airport, Airplane, Airline ]
      expect(subject.all).to eq [ Airline, Airplane, Airport ]
    end

    context 'when there is abstract class' do
      it 'filters out abstract class' do
        allow(ActiveRecord::Base).to receive(:descendants).and_return [ AbstractAirport ]
        expect(subject.all).to be_blank
      end
    end

    context 'when there is HABTM class' do
      it 'filters out HABTM class' do
        allow(ActiveRecord::Base).to receive(:descendants).and_return [ Airplane::HABTM_Airports ]
        expect(subject.all).to be_blank
      end
    end

    context 'when there is anonymous class' do
      it 'filters out anonymous class' do
        anonymous_class = Class.new do
          def self.abstract_class?
            false
          end
        end
        allow(ActiveRecord::Base).to receive(:descendants).and_return [ anonymous_class ]
        expect(subject.all).to be_blank
      end
    end
  end
end
