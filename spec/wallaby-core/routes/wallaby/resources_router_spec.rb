# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ResourcesRouter do
  # TODO: revisit the spec and try to avoid using stub/mock
  # NOTE: this is a spec to specify that the request being dispatched to the correct controler and action
  # it does not test the actual action, see integration test for more
  describe '#call' do
    let(:action_name) { 'index' }
    let(:mocked_env) do
      Hash(
        ActionDispatch::Http::Parameters::PARAMETERS_KEY => params,
        'SCRIPT_NAME' => '/admin',
        'rack.input' => StringIO.new,
        'REQUEST_METHOD' => 'GET'
      )
    end

    let(:params) { Hash resources: resources_name, action: action_name }
    let(:mocked_action) { ->(_env) { response } }
    let(:response) { [200, {}, [action_name]] }
    let(:default_controller) { Admin::ApplicationController }

    context 'when model class exists' do
      context 'when controller not exists' do
        let(:resources_name) { 'products' }

        it 'shows index page' do
          expect(default_controller).to receive(:action).with(action_name) { mocked_action }
          expect(subject.call(mocked_env)).to eq response
        end

        context 'when action is not found' do
          let(:action_name) { 'unknown_action' }

          it 'shows not found' do
            expect(default_controller).to receive(:action).with(action_name) { raise AbstractController::ActionNotFound }
            expect(default_controller).to receive(:action).with(:not_found) { mocked_action }
            subject.call mocked_env
          end
        end

        context 'when default controller is provided' do
          let(:params) { Hash resources: resources_name, action: action_name, resources_controller: resources_controller }
          let(:resources_controller) { InnerController }

          it 'shows index page' do
            expect(resources_controller).to receive(:action).with(action_name) { mocked_action }
            expect(default_controller).not_to receive(:action)
            subject.call mocked_env
          end
        end
      end

      context 'when controller exists' do
        let(:resources_name) { 'categories' }

        it 'shows index page' do
          expect(Admin::CategoriesController).to receive(:action).with(action_name) { mocked_action }
          subject.call mocked_env
        end

        context 'when action is not found' do
          let(:action_name) { 'unknown_action' }

          it 'calls not_found' do
            expect(Admin::CategoriesController).to receive(:action).with(action_name) { raise AbstractController::ActionNotFound }
            expect(default_controller).to receive(:action).with(:not_found) { mocked_action }
            subject.call mocked_env
          end
        end

        context 'when it passes a param id as action for show route' do
          let(:params) { Hash resources: resources_name, action: action_name, id: action_id }
          let(:action_name) { 'show' }
          let(:action_id) { 'history' }

          before do
            stub_const 'Queen', Class.new(ActiveRecord::Base)
            stub_const 'Admin::CategoriesController', (Class.new(default_controller) { def history; end })
          end

          it 'calls show' do
            expect(Admin::CategoriesController).to receive(:action).with(action_name) { mocked_action }
            subject.call mocked_env
          end

          context 'when default controller is provided' do
            let(:params) { Hash resources: resources_name, action: action_name, resources_controller: resources_controller }
            let(:resources_controller) { InnerController }
            let(:default_controller) { resources_controller }

            it 'shows index page' do
              expect(Admin::CategoriesController).to receive(:action).with(action_name) { mocked_action }
              expect(resources_controller).not_to receive(:action)
              expect(default_controller).not_to receive(:action)
              subject.call mocked_env
            end
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
          let(:action_name) { 'unknown_action' }

          it 'shows not found' do
            expect(default_controller).not_to receive(:action).with(action_name) { raise AbstractController::ActionNotFound }
            expect(default_controller).to receive(:action).with(:not_found) { mocked_action }
            subject.call mocked_env
          end
        end
      end

      context 'when model is array' do
        let(:resources_name) { 'arrays' }

        it 'shows not found' do
          expect(default_controller).to receive(:action).with(:unprocessable_entity) { mocked_action }
          subject.call mocked_env
        end
      end
    end
  end
end
