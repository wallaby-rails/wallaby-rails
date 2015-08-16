require 'rails_helper'

describe Wallaby::ResourcesController do
  describe 'class methods ' do
    describe '.resources_name' do
      it 'returns nil' do
        expect(described_class.resources_name).to be_nil
      end
    end

    describe '.model_class' do
      it 'returns nil' do
        expect(described_class.model_class).to be_nil
      end
    end
  end

  describe 'instance methods ' do
    before do
      allow(subject).to receive(:params).and_return({ resources: 'fish_and_chips' })
    end

    describe '#resources_name' do
      it 'returns resources name from params' do
        expect(subject.resources_name).to eq 'fish_and_chips'
      end
    end

    describe '#resource_name' do
      it 'returns resource name from params' do
        expect(subject.resource_name).to eq 'fish_and_chip'
      end
    end

    describe '#model_class' do
      it 'returns model class for resource' do
        class FishAndChip; end
        expect(subject.model_class).to eq FishAndChip
      end
    end
  end

  context 'for subclasses' do
    let(:subclasses_controller) do
      class CampervansController < described_class; end
      CampervansController
    end

    before do
      class Campervan; end
    end

    describe 'class methods ' do
      describe '.resources_name' do
        it 'returns resources name from controller name' do
          expect(subclasses_controller.resources_name).to eq 'campervans'
        end
      end

      describe '.model_class' do
        it 'returns model class' do
          expect(subclasses_controller.model_class).to eq Campervan
        end
      end
    end

    describe 'instance methods ' do
      let(:controller_instance) { subclasses_controller.new }
      before do
        allow(controller_instance).to receive(:params).and_return({ resources: 'something_else' })
      end

      describe '#resources_name' do
        it 'returns resources name from params' do
          expect(controller_instance.resources_name).to eq 'campervans'
        end
      end

      describe '#resource_name' do
        it 'returns resource name from params' do
          expect(controller_instance.resource_name).to eq 'campervan'
        end
      end

      describe '#model_class' do
        it 'returns model class for resource' do
          expect(controller_instance.model_class).to eq Campervan
        end
      end
    end
  end
end