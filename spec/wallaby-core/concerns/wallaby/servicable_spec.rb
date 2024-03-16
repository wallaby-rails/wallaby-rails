# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '.model_servicer && .application_servicer' do
    it 'returns nil' do
      expect(described_class.model_servicer).to be_nil
      expect(described_class.application_servicer).to eq Wallaby::ModelServicer
    end

    context 'when subclass' do
      let!(:subclass1) { stub_const 'ApplesController', Class.new(described_class) }
      let!(:subclass2) { stub_const 'ThingsController', Class.new(subclass1) }
      let!(:application_servicer) { stub_const 'ApplicationServicer', base_class_from(Wallaby::ModelServicer) }
      let!(:apple_servicer) { stub_const 'AppleServicer', Class.new(application_servicer) }
      let!(:thing_servicer) { stub_const 'ThingServicer', Class.new(apple_servicer) }
      let!(:apple) { stub_const 'Apple', Class.new(ActiveRecord::Base) }
      let!(:thing) { stub_const 'Thing', Class.new(ActiveRecord::Base) }

      it 'returns servicer class' do
        expect(subclass1.model_servicer).to eq AppleServicer
        expect(subclass1.application_servicer).to eq Wallaby::ModelServicer
        expect(subclass2.model_servicer).to eq ThingServicer
        expect(subclass2.application_servicer).to eq Wallaby::ModelServicer
      end
    end
  end

  describe '#current_servicer' do
    let!(:servicer) { stub_const 'AllPostgresTypeServicer', Class.new(Wallaby::ModelServicer) }

    it 'returns model servicer for existing resource servicer' do
      controller.params[:resources] = 'all_postgres_types'
      expect(controller.current_servicer).to be_a AllPostgresTypeServicer
    end

    it 'returns model servicer for non-existing resource servicer' do
      controller.params[:resources] = 'orders'
      expect(controller.current_servicer).to be_a Wallaby::ModelServicer
    end
  end
end
