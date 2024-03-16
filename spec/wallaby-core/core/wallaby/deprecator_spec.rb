# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Deprecator do
  describe '.alert' do
    context 'when version is lower than current version' do
      context 'when class method' do
        it 'raises error' do
          stub_const('AClass', Class.new do
            def self.class_method
              Wallaby::Deprecator.alert method(__callee__), from: '0.1', alternative: method(:alternative_class_method)
              'return for class_method'
            end

            def self.alternative_class_method
              'return for alternative_class_method'
            end
          end)

          expect { AClass.class_method }.to raise_error Wallaby::MethodRemoved, 'ERROR: AClass.class_method is removed since wallaby-core 0.1. Please use AClass.alternative_class_method instead.'

          stub_const('AModule', Module.new do
            def self.class_method
              Wallaby::Deprecator.alert method(__callee__), from: '0.1', alternative: method(:alternative_class_method)
              'return for class_method'
            end

            def self.alternative_class_method
              'return for alternative_class_method'
            end
          end)

          expect { AModule.class_method }.to raise_error Wallaby::MethodRemoved, 'ERROR: AModule.class_method is removed since wallaby-core 0.1. Please use AModule.alternative_class_method instead.'
        end
      end

      context 'when instance method' do
        it 'raises error' do
          stub_const('AnObject', Class.new do
            def instance_method
              Wallaby::Deprecator.alert method(__callee__), from: '0.1', alternative: method(:alternative_instance_method)
              'return for instance_method'
            end

            def alternative_instance_method
              'return for alternative_instance_method'
            end
          end)

          expect { AnObject.new.instance_method }.to raise_error Wallaby::MethodRemoved, 'ERROR: AnObject#instance_method is removed since wallaby-core 0.1. Please use AnObject#alternative_instance_method instead.'
        end
      end
    end

    context 'when version is higher than current version' do
      context 'when class method' do
        it 'logs the message' do
          stub_const('BClass', Class.new do
            def self.class_method
              Wallaby::Deprecator.alert method(__callee__), from: '99.99', alternative: method(:alternative_class_method)
              'return for class_method'
            end

            def self.alternative_class_method
              'return for alternative_class_method'
            end
          end)

          expect(Rails.logger).to receive(:warn).with(a_string_including('DEPRECATED: BClass.class_method will be removed from wallaby-core 99.99. Please use BClass.alternative_class_method instead.'))
          BClass.class_method

          stub_const('BModule', Module.new do
            def self.class_method
              Wallaby::Deprecator.alert method(__callee__), from: '99.99', alternative: method(:alternative_class_method)
              'return for class_method'
            end

            def self.alternative_class_method
              'return for alternative_class_method'
            end
          end)

          expect(Rails.logger).to receive(:warn).with(a_string_including('DEPRECATED: BModule.class_method will be removed from wallaby-core 99.99. Please use BModule.alternative_class_method instead.'))
          BModule.class_method
        end
      end

      context 'when instance method' do
        it 'logs the message' do
          stub_const('AnthorObject', Class.new do
            def instance_method
              Wallaby::Deprecator.alert method(__callee__), from: '99.99', alternative: method(:alternative_instance_method)
              'return for instance_method'
            end

            def alternative_instance_method
              'return for alternative_instance_method'
            end
          end)

          expect(Rails.logger).to receive(:warn).with(a_string_including('DEPRECATED: AnthorObject#instance_method will be removed from wallaby-core 99.99. Please use AnthorObject#alternative_instance_method instead.'))
          AnthorObject.new.instance_method
        end
      end
    end
  end
end
