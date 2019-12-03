require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '.engine_name' do
    it 'returns nil' do
      expect(described_class.engine_name).to be_nil
    end

    context 'when subclass' do
      let!(:subclass1) { stub_const 'ApplesController', Class.new(described_class) }
      let!(:subclass2) { stub_const 'ThingsController', Class.new(subclass1) }

      it 'inherits the configuration' do
        expect(subclass1.engine_name).to be_nil
        subclass1.engine_name = 'apple_engine'
        expect(subclass1.engine_name).to eq 'apple_engine'
        expect(subclass2.engine_name).to eq 'apple_engine'
      end
    end
  end

  describe '#current_engine_name && #current_engine' do
    it 'returns engine name' do
      expect(controller.request.env['SCRIPT_NAME']).to eq '/admin'
      expect(controller.current_engine_name).to eq 'wallaby_engine'
      if version?('< 5.1')
        expect(controller.current_engine.root_path(script_name: '/admin')).to eq '/admin/'
      else
        expect(controller.current_engine.root_path).to eq '/admin/'
      end
      controller.request.env['SCRIPT_NAME'] = '/inner'
      expect(controller.current_engine_name).to eq 'wallaby_engine'
      if version?('< 5.1')
        expect(controller.current_engine.root_path(script_name: '/admin')).to eq '/admin/'
      else
        expect(controller.current_engine.root_path).to eq '/admin/'
      end
    end

    context 'when script name is different' do
      it 'returns engine name' do
        controller.request.env['SCRIPT_NAME'] = '/inner'
        expect(controller.current_engine_name).to eq 'inner_engine'
        if version?('< 5.1')
          expect(controller.current_engine.root_path(script_name: '/inner')).to eq '/inner/'
        else
          expect(controller.current_engine.root_path).to eq '/inner/'
        end
      end
    end

    context 'when script name is blank' do
      it 'returns empty string' do
        controller.request.env['SCRIPT_NAME'] = ''
        expect(controller.current_engine_name).to eq ''
        expect(controller.current_engine).to be_nil
      end
    end
  end
end
