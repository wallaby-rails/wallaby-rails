# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '.model_authorizer && .application_authorizer' do
    it 'returns nil' do
      expect(described_class.model_authorizer).to be_nil
      expect(described_class.application_authorizer).to eq Wallaby::ModelAuthorizer
    end

    context 'when subclass' do
      let!(:subclass1) { stub_const 'ApplesController', Class.new(described_class) }
      let!(:subclass2) { stub_const 'ThingsController', Class.new(subclass1) }
      let!(:application_authorizer) { stub_const 'ApplicationAuthorizer', base_class_from(Wallaby::ModelAuthorizer) }
      let!(:apple_authorizer) { stub_const 'AppleAuthorizer', Class.new(application_authorizer) }
      let!(:thing_authorizer) { stub_const 'ThingAuthorizer', Class.new(apple_authorizer) }
      let!(:apple) { stub_const 'Apple', Class.new(ActiveRecord::Base) }
      let!(:thing) { stub_const 'Thing', Class.new(ActiveRecord::Base) }

      it 'returns authorizer classes' do
        expect(subclass1.model_authorizer).to eq AppleAuthorizer
        expect(subclass1.application_authorizer).to eq Wallaby::ModelAuthorizer
        expect(subclass2.model_authorizer).to eq ThingAuthorizer
        expect(subclass2.application_authorizer).to eq Wallaby::ModelAuthorizer
      end
    end
  end

  describe '#current_authorizer' do
    it 'returns model authorizer' do
      controller.params[:resources] = 'orders'
      expect(controller.current_authorizer).to be_a Wallaby::ModelAuthorizer
    end
  end

  describe '#authorizer_of' do
    it 'returns model authorizer' do
      expect(controller.send(:authorizer_of, Order)).to be_a Wallaby::ModelAuthorizer
    end
  end

  describe '#authorized? & #unauthorized?' do
    it 'returns boolean' do
      expect(controller).to be_authorized(:index, AllPostgresType)
      expect(controller).to be_authorized(:index, AllPostgresType.new)
      expect(controller).not_to be_unauthorized(:index, AllPostgresType)
      expect(controller).not_to be_unauthorized(:index, AllPostgresType.new)

      expect(controller).not_to be_authorized(:index, nil)
      expect(controller).to be_unauthorized(:index, nil)
    end
  end
end
