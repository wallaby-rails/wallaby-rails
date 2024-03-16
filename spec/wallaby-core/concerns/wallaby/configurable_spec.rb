# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '.resource_decorator && .application_decorator' do
    it 'returns decorator class' do
      expect(described_class.resource_decorator).to be_nil
      expect(described_class.application_decorator).to eq Wallaby::ResourceDecorator
    end

    context 'when subclass' do
      let!(:application_controller) { stub_const 'Admin::ApplicationController', base_class_from(described_class) }
      let!(:subclass1) { stub_const 'ApplesController', Class.new(application_controller) }
      let!(:subclass2) { stub_const 'ThingsController', Class.new(subclass1) }
      let!(:application_decorator) { stub_const 'ApplicationDecorator', base_class_from(Wallaby::ResourceDecorator) }
      let!(:another_application_decorator) { stub_const 'AnotherApplicationDecorator', base_class_from(application_decorator) }
      let!(:apple_decorator) { stub_const 'AppleDecorator', Class.new(another_application_decorator) }
      let!(:thing_decorator) { stub_const 'ThingDecorator', Class.new(apple_decorator) }
      let!(:apple) { stub_const 'Apple', Class.new(ActiveRecord::Base) }
      let!(:thing) { stub_const 'Thing', Class.new(ActiveRecord::Base) }

      it 'returns decorator class' do
        expect(subclass1.resource_decorator).to eq AppleDecorator
        expect(subclass1.application_decorator).to eq ApplicationDecorator
        expect(subclass2.resource_decorator).to eq ThingDecorator
        expect(subclass2.application_decorator).to eq ApplicationDecorator
      end
    end
  end

  describe '.models && .models_to_exclude && .all_models' do
    it 'returns models' do
      expect(described_class.models).to be_blank
      expect(described_class.models_to_exclude.to_a).to include(ActiveRecord::SchemaMigration) if version?('< 7.1')

      if version?('>= 6.0') && version?('< 7.1')
        expect(described_class.models_to_exclude.to_a).to include(ActiveRecord::InternalMetadata)
      end

      expect(described_class.all_models).not_to include(ActiveRecord::SchemaMigration)
      expect(described_class.all_models).not_to include(ActiveRecord::InternalMetadata) if version?('>= 6.0')
    end

    context 'when subclass' do
      let!(:application_controller) { stub_const 'Admin::ApplicationController', base_class_from(described_class) }

      it 'returns models' do
        expect(application_controller.models).to be_blank

        if version?('< 7.1')
          expect(application_controller.models_to_exclude.to_a).to include(ActiveRecord::SchemaMigration)
        end

        if version?('>= 5.2') && version?('< 7.1')
          expect(application_controller.models_to_exclude.to_a).to include(ActiveRecord::InternalMetadata)
        end

        expect(application_controller.all_models).not_to include(ActiveRecord::SchemaMigration)
        expect(application_controller.all_models).not_to include(ActiveRecord::InternalMetadata) if version?('>= 5.2')

        Admin::ApplicationController.models_to_exclude = Product, *Admin::ApplicationController.models_to_exclude.to_a
        expect(application_controller.models).to be_blank
        expect(application_controller.models_to_exclude.to_a).to include(Product)
        expect(application_controller.all_models).not_to include(Product)

        Admin::ApplicationController.models = Product
        expect(application_controller.models.to_a).to eq([Product])
        expect(application_controller.models_to_exclude.to_a).to include(Product)
        expect(application_controller.all_models).to include(Product)
      end
    end
  end

  describe '.logout_path & .logout_method & .email_method' do
    it 'returns models' do
      expect(described_class.logout_path).to be_nil
      expect(described_class.logout_method).to be_nil
    end

    context 'when subclass' do
      let!(:application_controller) { stub_const 'Admin::ApplicationController', base_class_from(described_class) }

      it 'returns models' do
        expect(application_controller.logout_path).to be_nil
        expect(application_controller.logout_method).to be_nil
        expect(application_controller.email_method).to be_nil

        application_controller.logout_path = 'signout'
        application_controller.logout_method = 'put'
        application_controller.email_method = 'email_address'
        expect(application_controller.logout_path).to eq 'signout'
        expect(application_controller.logout_method).to eq 'put'
        expect(application_controller.email_method).to eq 'email_address'

        application_controller.logout_path = :signout
        application_controller.logout_method = :put
        application_controller.email_method = :email_address
        expect(application_controller.logout_path).to eq :signout
        expect(application_controller.logout_method).to eq :put
        expect(application_controller.email_method).to eq :email_address

        application_controller.logout_path = nil
        application_controller.logout_method = nil
        application_controller.email_method = nil
        expect(application_controller.logout_path).to be_nil
        expect(application_controller.logout_method).to be_nil
        expect(application_controller.email_method).to be_nil

        expect { application_controller.logout_path = Rails.root }.to raise_error ArgumentError, 'Please provide a String/Symbol value or nil'
        expect { application_controller.logout_method = 'something else' }.to raise_error ArgumentError, 'Please provide valid RFC2616 HTTP method (e.g. options, get, head, post, put, delete, trace, connect) or nil'
        expect { application_controller.email_method = Rails.root }.to raise_error ArgumentError, 'Please provide a String/Symbol value or nil'
      end
    end
  end

  describe '.max_text_length' do
    it 'returns models' do
      expect(described_class.max_text_length).to eq 20
    end

    context 'when subclass' do
      let!(:application_controller) { stub_const 'Admin::ApplicationController', base_class_from(described_class) }

      it 'returns models' do
        expect(application_controller.max_text_length).to eq 20

        application_controller.max_text_length = 50
        expect(application_controller.max_text_length).to eq 50

        application_controller.max_text_length = nil
        expect(application_controller.max_text_length).to eq 20

        expect { application_controller.max_text_length = Rails.root }.to raise_error ArgumentError, 'Please provide a Integer value or nil'
      end
    end
  end

  describe '.page_size' do
    it 'returns models' do
      expect(described_class.page_size).to eq 20
    end

    context 'when subclass' do
      let!(:application_controller) { stub_const 'Admin::ApplicationController', base_class_from(described_class) }

      it 'returns models' do
        expect(application_controller.page_size).to eq 20

        application_controller.page_size = 50
        expect(application_controller.page_size).to eq 50

        application_controller.page_size = nil
        expect(application_controller.page_size).to eq 20

        expect { application_controller.page_size = Rails.root }.to raise_error ArgumentError, 'Please provide a Integer value or nil'
      end
    end
  end

  describe '.sorting_strategy' do
    it 'returns models' do
      expect(described_class.sorting_strategy).to eq :multiple
    end

    context 'when subclass' do
      let!(:application_controller) { stub_const 'Admin::ApplicationController', base_class_from(described_class) }

      it 'returns models' do
        expect(application_controller.sorting_strategy).to eq :multiple

        application_controller.sorting_strategy = :single
        expect(application_controller.sorting_strategy).to eq :single

        application_controller.sorting_strategy = nil
        expect(application_controller.sorting_strategy).to eq :multiple

        expect { application_controller.sorting_strategy = Rails.root }.to raise_error ArgumentError, 'Please provide a value of :multiple, :single or nil'
      end
    end
  end
end
