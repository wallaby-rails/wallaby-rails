require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '.resource_decorator && .application_decorator' do
    it 'returns nil' do
      expect(described_class.resource_decorator).to be_nil
      expect(described_class.application_decorator).to be_nil
    end

    context 'when subclass' do
      let!(:subclass1) { stub_const 'ApplesController', Class.new(described_class) }
      let!(:subclass2) { stub_const 'ThingsController', Class.new(subclass1) }
      let!(:application_decorator) { stub_const 'ApplicationDecorator', Class.new(Wallaby::ResourceDecorator) }
      let!(:another_decorator) { stub_const 'AnotherDecorator', Class.new(Wallaby::ResourceDecorator) }
      let!(:apple_decorator) { stub_const 'AppleDecorator', Class.new(application_decorator) }
      let!(:thing_decorator) { stub_const 'ThingDecorator', Class.new(apple_decorator) }
      let!(:apple) { stub_const 'Apple', Class.new(ActiveRecord::Base) }
      let!(:thing) { stub_const 'Thing', Class.new(ActiveRecord::Base) }

      it 'is nil' do
        expect(subclass1.resource_decorator).to be_nil
        expect(subclass1.application_decorator).to be_nil
        expect(subclass2.resource_decorator).to be_nil
        expect(subclass2.application_decorator).to be_nil
      end

      it 'returns decorator classes' do
        subclass1.resource_decorator = apple_decorator
        expect(subclass1.resource_decorator).to eq apple_decorator
        expect(subclass2.resource_decorator).to be_nil

        subclass1.application_decorator = application_decorator
        expect(subclass1.application_decorator).to eq application_decorator
        expect(subclass2.application_decorator).to eq application_decorator

        expect { subclass1.application_decorator = another_decorator }.to raise_error ArgumentError, 'AppleDecorator does not inherit from AnotherDecorator.'
      end
    end
  end

  describe '#current_model_decorator' do
    it 'returns model decorator for existing resource decorator' do
      controller.params[:resources] = 'all_postgres_types'
      expect(controller.current_model_decorator).to eq AllPostgresTypeDecorator.model_decorator
    end

    it 'returns model decorator for non-existing resource decorator' do
      controller.params[:resources] = 'orders'
      expect(controller.current_model_decorator).to be_a Wallaby::ModelDecorator
    end
  end
end
