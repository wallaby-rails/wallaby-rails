require 'rails_helper'

describe Wallaby::ResourcesRouter, clear: :object_space do
  describe '#call' do
    let(:mocked_env) do
      {
        'action_dispatch.request.path_parameters' => {
          resources: 'knights', action: 'status'
        }
      }
    end
    let(:mocked_action) { double 'Action', call: nil }

    it 'shows not found page when resources_name is not found' do
      expect(Wallaby::ResourcesController).to receive(:action).with('status') { mocked_action }
      subject.call mocked_env
    end

    context 'when action is not found' do
      it 'calls not_found' do
        expect(Wallaby::ResourcesController).to receive(:action).with('status') { fail AbstractController::ActionNotFound }
        expect(Wallaby::ResourcesController).to receive(:action).with(:not_found) { mocked_action }
        subject.call mocked_env
      end
    end

    context 'when resources_name found' do
      context 'and controller name is different from resources_name' do
        it 'calls KnightsController' do
          stub_const 'KnightsController', Class.new(Wallaby::ResourcesController)

          expect(KnightsController).to receive(:action).with('status') { mocked_action }
          subject.call mocked_env
        end
      end
    end
  end
end
