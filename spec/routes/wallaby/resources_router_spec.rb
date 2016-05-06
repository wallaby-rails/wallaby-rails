require 'rails_helper'

describe Wallaby::ResourcesRouter do
  describe '#call' do
    let(:action_name) { 'index' }
    let(:mocked_env) do
      Hash 'action_dispatch.request.path_parameters' => {
        resources: resources_name, action: action_name
      }
    end
    let(:mocked_action) { double 'Action', call: nil }
    let(:default_controller) { Wallaby::ResourcesController }

    context 'when model class exists' do
      context 'when controller not exists' do
        let(:resources_name) { 'kings' }
        before { class King; end }

        it 'shows index page' do
          expect(default_controller).to receive(:action).with(action_name) { mocked_action }
          subject.call mocked_env
        end

        context 'when action is not found' do
          let(:action_name) { 'unknown' }

          it 'shows not found' do
            expect(default_controller).to receive(:action).with(action_name) { fail AbstractController::ActionNotFound }
            expect(default_controller).to receive(:action).with(:not_found) { mocked_action }
            subject.call mocked_env
          end
        end
      end

      context 'when controller exists' do
        let(:resources_name) { 'queens' }
        before do
          class Queen; end
          class QueensController < default_controller; end
        end

        it 'shows index page' do
          expect(QueensController).to receive(:action).with(action_name) { mocked_action }
          subject.call mocked_env
        end

        context 'when action is not found' do
          let(:action_name) { 'unknown' }

          it 'calls not_found' do
            expect(QueensController).to receive(:action).with(action_name) { fail AbstractController::ActionNotFound }
            expect(default_controller).to receive(:action).with(:not_found) { mocked_action }
            subject.call mocked_env
          end
        end

        context 'when it passes a param id as action for show route' do
          let(:mocked_env) do
            Hash 'action_dispatch.request.path_parameters' => {
              resources: resources_name, action: action_name, id: action_id
            }
          end
          let(:action_name) { 'show' }
          let(:action_id) { 'history' }

          before do
            class Queen; end
            class QueensController < default_controller; def history; end; end
          end

          it 'calls history' do
            expect(QueensController).to receive(:action).with(action_id) { mocked_action }
            subject.call mocked_env
            expect(mocked_env['action_dispatch.request.path_parameters'][:action]).to eq action_id
          end
        end
      end
    end

    context 'when model class not exists' do
      let(:resources_name) { 'knights' }

      context 'when controller not exists' do
        it 'shows not found' do
          expect(default_controller).to receive(:action).with(:not_found) { mocked_action }
          subject.call mocked_env
        end

        context 'when action is not found' do
          let(:action_name) { 'unknown' }

          it 'shows not found' do
            expect(default_controller).to receive(:action).with(:not_found) { mocked_action }
            subject.call mocked_env
          end
        end
      end
    end
  end
end
