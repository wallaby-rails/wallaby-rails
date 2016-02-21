require 'rails_helper'

describe Wallaby::ResourcesRouter do
  describe '#call' do
    let(:env) { { 'action_dispatch.request.path_parameters' => { resources: resources, action: 'status' } } }
    let(:action) { double 'Action', call: nil }
    let(:resources) { 'aliens' }

    before { Rails.cache.clear }
    after { subject.call env }

    it 'shows not found page when resources_name is not found' do
      expect(Wallaby::ResourcesController).to receive(:action).with('status') { action }
    end

    context 'when action is not found' do
      it 'calls not_found' do
        expect(Wallaby::ResourcesController).to receive(:action).with('status') { fail AbstractController::ActionNotFound }
        expect(Wallaby::ResourcesController).to receive(:action).with(:not_found) { action }
      end
    end

    context 'when resources_name found' do
      context 'and controller name is different from resources_name' do
        before { stub_const 'AliensController', Class.new(Wallaby::ResourcesController) }
        it 'calls AliensController' do
          expect(AliensController).to receive(:action).with('status') { action }
        end
      end
    end
  end
end
