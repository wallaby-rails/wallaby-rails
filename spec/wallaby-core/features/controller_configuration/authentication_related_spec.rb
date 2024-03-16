# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ResourcesController do
  {
    logout_path: ['logout', 'users/custom_logout'],
    logout_method: %w[delete put],
    email_method: %w[email email_address]
  }.each do |config_method, (application_value, user_value)|
    describe ".#{config_method}" do
      it 'returns nil' do
        expect(described_class.try(config_method)).to be_nil
      end

      context 'when subclasses' do
        let(:application_value) { 'custom_value' }
        let(:application_controller) do
          stub_const('Admin::ApplicationController', base_class_from(described_class))
        end

        let(:user_controller) do
          stub_const('Admin::ApplicationController', base_class_from(application_controller))
        end

        before do
          application_controller.try :"#{config_method}=", application_value
        end

        it "returns its #{config_method}" do
          expect(application_controller.try(config_method)).to eq application_value
          expect(user_controller.try(config_method)).to eq application_value
        end

        context "when user controller has its own #{config_method}" do
          let(:user_value) { 'user_value' }

          it "returns its #{config_method}" do
            user_controller.try :"#{config_method}=", user_value
            expect(application_controller.try(config_method)).to eq application_value
            expect(user_controller.try(config_method)).to eq user_value
          end
        end

        context "when user controller has its own #{config_method} as Symbol" do
          let(:user_value) { :user_value }

          it "returns its #{config_method}" do
            user_controller.try :"#{config_method}=", user_value
            expect(application_controller.try(config_method)).to eq application_value
            expect(user_controller.try(config_method)).to eq user_value
          end
        end

        context "when user controller's #{config_method} is set to an invalid value" do
          let(:invalid_value) { 1 }

          it 'raises error' do
            expect { user_controller.try :"#{config_method}=", invalid_value }.to raise_error ArgumentError
          end
        end
      end
    end
  end
end
