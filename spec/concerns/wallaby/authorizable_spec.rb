require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '.model_authorizer && .application_authorizer' do
    it 'returns nil' do
      expect(described_class.model_authorizer).to be_nil
      expect(described_class.application_authorizer).to be_nil
    end

    context 'when subclass' do
      let!(:subclass1) { stub_const 'ApplesController', Class.new(described_class) }
      let!(:subclass2) { stub_const 'ThingsController', Class.new(subclass1) }
      let!(:application_authorizer) { stub_const 'ApplicationAuthorizer', Class.new(Wallaby::ModelAuthorizer) }
      let!(:another_authorizer) { stub_const 'AnotherAuthorizer', Class.new(Wallaby::ModelAuthorizer) }
      let!(:apple_authorizer) { stub_const 'AppleAuthorizer', Class.new(application_authorizer) }
      let!(:thing_authorizer) { stub_const 'ThingAuthorizer', Class.new(apple_authorizer) }
      let!(:apple) { stub_const 'Apple', Class.new(ActiveRecord::Base) }
      let!(:thing) { stub_const 'Thing', Class.new(ActiveRecord::Base) }

      it 'is nil' do
        expect(subclass1.model_authorizer).to be_nil
        expect(subclass1.application_authorizer).to be_nil
        expect(subclass2.model_authorizer).to be_nil
        expect(subclass2.application_authorizer).to be_nil
      end

      it 'returns authorizer classes' do
        subclass1.model_authorizer = apple_authorizer
        expect(subclass1.model_authorizer).to eq apple_authorizer
        expect(subclass2.model_authorizer).to be_nil

        subclass1.application_authorizer = application_authorizer
        expect(subclass1.application_authorizer).to eq application_authorizer
        expect(subclass2.application_authorizer).to eq application_authorizer

        expect { subclass1.application_authorizer = another_authorizer }.to raise_error ArgumentError, 'AppleAuthorizer does not inherit from AnotherAuthorizer.'
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
