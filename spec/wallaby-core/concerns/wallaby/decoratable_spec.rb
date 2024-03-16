# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '.resource_decorator && .application_decorator' do
    it 'returns nil' do
      expect(described_class.resource_decorator).to be_nil
      expect(described_class.application_decorator).to eq Wallaby::ResourceDecorator
    end

    context 'when subclass' do
      let!(:application_controller) { stub_const 'Admin::ApplicationController', base_class_from(described_class) }
      let!(:subclass1) { stub_const 'ApplesController', Class.new(application_controller) }
      let!(:subclass2) { stub_const 'ThingsController', Class.new(subclass1) }
      let!(:application_decorator) { stub_const 'ApplicationDecorator', base_class_from(Wallaby::ResourceDecorator) }
      let!(:another_application_decorator) { stub_const 'AnotherApplicationDecorator', base_class_from(application_decorator) }
      let!(:apple_decorator) { stub_const 'AppleDecorator', Class.new(another_application_decorator) }
      let!(:thing_decorator) { stub_const 'ThingDecorator', Class.new(apple_decorator) }
      let!(:apple) { stub_const 'Apple', Class.new(ActiveRecord::Base) }
      let!(:thing) { stub_const 'Thing', Class.new(ActiveRecord::Base) }

      it 'returns decorator class' do
        expect(subclass1.resource_decorator).to eq AppleDecorator
        expect(subclass1.application_decorator).to eq application_decorator
        expect(subclass2.resource_decorator).to eq ThingDecorator
        expect(subclass2.application_decorator).to eq application_decorator
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
