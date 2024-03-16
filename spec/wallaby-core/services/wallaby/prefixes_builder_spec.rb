# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::PrefixesBuilder do
  describe '#execute' do
    subject do
      described_class.new(
        prefixes: prefixes,
        script_name: script_name,
        resources_name: resources_name,
        controller_class: current_controller_class
      ).execute
    end

    let(:prefixes) { current_controller_class.new.public_send(:original_prefixes) }
    let(:script_name) { '/admin' }
    let(:resources_name) { 'order::items' }
    let(:current_controller_class) { Wallaby::ResourcesController }

    it { is_expected.to eq ['admin/order/items', 'wallaby/resources', 'application'] }

    context 'when resources_name is empty' do
      let(:resources_name) { nil }

      it { is_expected.to eq ['wallaby/resources', 'application'] }
    end

    context 'when script_name is empty' do
      let(:script_name) { '' }

      it { is_expected.to eq ['order/items', 'wallaby/resources', 'application'] }
    end

    context 'when current controller is Admin::ApplicationController' do
      let(:current_controller_class) { stub_const('Admin::ApplicationController', base_class_from(Wallaby::ResourcesController)) }

      it { is_expected.to eq ['admin/order/items', 'admin/application', 'wallaby/resources', 'application'] }

      context 'when resources_name is empty' do
        let(:resources_name) { nil }

        it { is_expected.to eq ['admin/application', 'wallaby/resources', 'application'] }
      end

      context 'when current controller is Admin::Order::ItemsController' do
        let(:application_controller) { stub_const('Admin::ApplicationController', base_class_from(Wallaby::ResourcesController)) }
        let(:current_controller_class) { stub_const('Admin::Order::ItemsController', Class.new(application_controller)) }

        it { is_expected.to eq ['admin/order/items', 'admin/application', 'wallaby/resources', 'application'] }

        context 'when resources_name is empty' do
          let(:resources_name) { nil }

          it { is_expected.to eq ['admin/order/items', 'admin/application', 'wallaby/resources', 'application'] }
        end
      end

      context 'when current controller is Admin::Custom::Order::ItemsController' do
        let(:application_controller) { stub_const('Admin::ApplicationController', base_class_from(Wallaby::ResourcesController)) }
        let(:current_controller_class) { stub_const('Admin::Custom::Order::ItemsController', Class.new(application_controller)) }

        it { is_expected.to eq ['admin/custom/order/items', 'admin/order/items', 'admin/application', 'wallaby/resources', 'application'] }

        context 'when resources_name is empty' do
          let(:resources_name) { nil }

          it { is_expected.to eq ['admin/custom/order/items', 'admin/application', 'wallaby/resources', 'application'] }
        end
      end
    end

    context 'when current controller is Order::ItemsController' do
      let(:current_controller_class) { Order::ItemsController }
      let(:script_name) { '' }

      it { is_expected.to eq ['order/items', 'base', 'application'] }
    end

    context 'when current controller is BlogsController' do
      let(:current_controller_class) { BlogsController }
      let(:resources_name) { 'blogs' }
      let(:script_name) { '' }

      it { is_expected.to eq %w[blogs application] }
    end
  end
end
