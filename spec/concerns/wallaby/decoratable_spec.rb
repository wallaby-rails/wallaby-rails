require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '.resource_decorator && .application_decorator' do
    it 'returns nil' do
      expect(described_class.resource_decorator).to be_nil
      expect(described_class.application_decorator).to be_nil
    end

    context 'subclass' do
      let!(:subclass1) { stub_const 'ApplesController', Class.new(Wallaby::ResourcesController) }
      let!(:subclass2) { stub_const 'ThingsController', Class.new(subclass1) }
      let!(:application_decorator) { stub_const 'ApplicationDecorator', Class.new(Wallaby::ResourceDecorator) }
      let!(:another_decorator) { stub_const 'AnotherDecorator', Class.new(Wallaby::ResourceDecorator) }

      it 'inherits the configuration' do
        expect(subclass1.resource_decorator).to be_nil
        subclass1.resource_decorator = 'apple_engine'
        expect(subclass1.resource_decorator).to eq 'apple_engine'
        expect(subclass2.resource_decorator).to eq 'apple_engine'
      end
    end
  end

  describe '#current_model_decorator' do
    it 'returns engine name' do
      expect(controller.request.env['SCRIPT_NAME']).to eq '/admin'
      expect(controller.current_model_decorator).to eq 'wallaby_engine'
      if version?('< 5.1')
        expect(controller.current_engine.root_path(script_name: '/admin')).to eq '/admin/'
      else
        expect(controller.current_engine.root_path).to eq '/admin/'
      end
      controller.request.env['SCRIPT_NAME'] = '/inner'
      expect(controller.current_model_decorator).to eq 'wallaby_engine'
      if version?('< 5.1')
        expect(controller.current_engine.root_path(script_name: '/admin')).to eq '/admin/'
      else
        expect(controller.current_engine.root_path).to eq '/admin/'
      end
    end
  end
end
