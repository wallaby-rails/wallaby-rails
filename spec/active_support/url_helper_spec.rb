require 'rails_helper'

if Rails::VERSION::MAJOR >= 5
  describe 'URL helpers', type: :helper do
    describe 'action_view/routing_url_for' do
      it 'returns url' do
        super_method = helper.method(:url_for).super_method
        expect(super_method.call(parameters!(controller: 'application', action: 'index'))).to eq '/test/purpose'
      end
    end

    describe 'wallaby_engine.resources_path helper' do
      it 'returns url' do
        expect(helper.wallaby_engine.resources_path(action: 'index', resources: 'products', script_name: '/admin')).to eq '/admin/products'

        if version?('< 5.0.0')
          expect(helper.wallaby_engine.resources_path(parameters!(action: 'index', resources: 'products'))).to match '/inner/products'
        elsif version?('5.0.0')
          expect(helper.wallaby_engine.resources_path(parameters!(action: 'index', resources: 'products'))).to match '/inner/%23%3CActionController::Parameters'
        elsif version?('~> 5.0')
          expect(helper.wallaby_engine.resources_path(parameters!(action: 'index', resources: 'products'))).to match '/inner/action=index&resources=products'
        else
          expect(helper.wallaby_engine.resources_path(parameters!(action: 'index', resources: 'products'))).to match '/admin/action=index&resources=products'
        end
      end
    end
  end

else

  describe Wallaby::ResourcesController, type: :controller do
    describe 'action_view/routing_url_for' do
      it 'returns url' do
        super_method = controller.method(:url_for).super_method
        expect(super_method.call(parameters!(controller: 'application', action: 'index'))).to include '/test/purpose'
      end
    end

    describe 'wallaby_engine.resources_path helper' do
      it 'returns url' do
        expect(controller.wallaby_engine.resources_path(action: 'index', resources: 'products', script_name: '/admin')).to eq '/admin/products'

        if version?('< 5.0.0')
          expect(controller.wallaby_engine.resources_path(parameters!(action: 'index', resources: 'products'))).to match '/inner/products'
        elsif version?('5.0.0')
          expect(controller.wallaby_engine.resources_path(parameters!(action: 'index', resources: 'products'))).to match '/inner/%23%3CActionController::Parameters'
        elsif version?('~> 5.0')
          expect(controller.wallaby_engine.resources_path(parameters!(action: 'index', resources: 'products'))).to match '/inner/action=index&resources=products'
        else
          expect(controller.wallaby_engine.resources_path(parameters!(action: 'index', resources: 'products'))).to match '/admin/action=index&resources=products'
        end
      end
    end
  end
end
