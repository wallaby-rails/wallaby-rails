# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ActiveRecord::ModelFinder do
  describe '#all' do
    it 'returns valid model classes in alphabetic order' do
      stub_const 'Airport', (Class.new do
                               def self.abstract_class?
                                 false
                               end
                             end)
      stub_const 'Airline', (Class.new do
                               def self.abstract_class?
                                 false
                               end
                             end)
      stub_const 'Airplane', (Class.new do
                                def self.abstract_class?
                                  false
                                end
                              end)

      expect(ActiveRecord::Base).to receive(:descendants).and_return [Airport, Airplane, Airline]
      expect(subject.all).to eq [Airline, Airplane, Airport]
    end

    context 'when it is an abstract class' do
      it 'filters out abstract class' do
        stub_const 'AbstractAirport', (Class.new do
                                         def self.abstract_class?
                                           true
                                         end
                                       end)

        expect(ActiveRecord::Base).to receive(:descendants).and_return [AbstractAirport]
        expect(subject.all).to be_blank
      end
    end

    context 'when it is an HABTM class' do
      it 'filters out HABTM class' do
        stub_const 'Airplane::HABTM_Airports', (Class.new do
                                                  def self.abstract_class?
                                                    false
                                                  end
                                                end)

        expect(ActiveRecord::Base).to receive(:descendants).and_return [Airplane::HABTM_Airports]
        expect(subject.all).to be_blank
      end
    end

    context 'when it is an anonymous class' do
      it 'filters out anonymous class' do
        anonymous_class = Class.new do
          def self.abstract_class?
            false
          end
        end

        expect(ActiveRecord::Base).to receive(:descendants).and_return [anonymous_class]
        expect(subject.all).to be_blank
      end
    end

    context 'when it is an invalid class name' do
      it 'filters out invalid class name' do
        stub_const 'InvalidClassName', (Class.new do
          def self.abstract_class?
            false
          end

          def self.name
            'primary::SchemaMigration'
          end
        end)

        expect(ActiveRecord::Base).to receive(:descendants).and_return [InvalidClassName]
        expect(subject.all).to be_blank
      end
    end
  end
end
