# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Classifier do
  describe '.class_name_of' do
    subject(:class_name) { described_class.class_name_of(object) }

    context 'when object is class' do
      let(:object) { Class }

      it { is_expected.to eq('Class') }

      context 'when object is anonymous class' do
        let(:object) { Class.new }

        it { is_expected.to be_nil }
      end
    end

    context 'when object is not a class' do
      context 'when object is string' do
        let(:object) { 'Class' }

        it { is_expected.to eq('Class') }

        context 'when object is empty string' do
          let(:object) { '' }

          it { is_expected.to eq('') }
        end
      end

      context 'when object is symbol' do
        let(:object) { :Class }

        it { is_expected.to eq('Class') }
      end

      context 'when object is integer' do
        let(:object) { 1 }

        it { is_expected.to eq('1') }
      end

      context 'when object is nil' do
        let(:object) { nil }

        it { is_expected.to be_nil }
      end
    end
  end

  describe '.to_class' do
    let(:raising) { false }

    context 'when class exists' do
      let(:class_name) { 'Product' }

      it { expect(described_class.to_class(class_name, raising: raising)).to eq(Product) }

      context 'when class has missing method error' do
        let(:class_name) { +'BrokenProduct' }

        it 'does not raise error nor cache the result' do
          expect(Wallaby::Map.class_name_error_map[class_name]).to eq(nil)
          expect(class_name).to receive(:constantize).and_call_original
          expect { described_class.to_class(class_name, raising: raising) }.not_to raise_error

          expect(Wallaby::Map.class_name_error_map[class_name]).to eq(nil)
          expect(class_name).to receive(:constantize).and_call_original
          expect { described_class.to_class(class_name, raising: raising) }.not_to raise_error
        end

        context 'when raising is true' do
          let(:raising) { true }

          it 'always raises error' do
            expect(Wallaby::Map.class_name_error_map[class_name]).to eq(nil)
            expect(class_name).to receive(:constantize).and_call_original
            expect { described_class.to_class(class_name, raising: raising) }.to raise_error(NameError, "undefined local variable or method `missing_class_method_called' for BrokenProduct:Class")

            expect(Wallaby::Map.class_name_error_map[class_name]).to eq(:name_error)
            expect(class_name).to receive(:constantize).and_call_original
            expect { described_class.to_class(class_name, raising: raising) }.to raise_error(NameError, "undefined local variable or method `missing_class_method_called' for BrokenProduct:Class")
          end
        end
      end
    end

    context 'when class not exists' do
      let(:class_name) { +'UnknownProduct' }

      it 'returns nil but does not cache the result' do
        expect(Wallaby::Map.class_name_error_map[class_name]).to eq(nil)
        expect(class_name).to receive(:constantize).and_call_original
        expect(described_class.to_class(class_name, raising: raising)).to be_nil

        expect(Wallaby::Map.class_name_error_map[class_name]).to eq(nil)
        expect(class_name).to receive(:constantize).and_call_original
        expect(described_class.to_class(class_name, raising: raising)).to be_nil
      end

      context 'when raising is true' do
        let(:raising) { true }

        it 'returns nil and caches the result' do
          expect(Wallaby::Map.class_name_error_map[class_name]).to eq(nil)
          expect(class_name).to receive(:constantize).and_call_original
          expect { described_class.to_class(class_name, raising: raising) }.not_to raise_error

          expect(Wallaby::Map.class_name_error_map[class_name]).to eq(:uninitialized)
          expect(class_name).not_to receive(:constantize)
          expect { described_class.to_class(class_name, raising: raising) }.not_to raise_error
        end
      end
    end

    context 'when class name is empty string' do
      let(:class_name) { '' }

      it { expect(described_class.to_class(class_name, raising: raising)).to be_nil }
    end
  end
end
