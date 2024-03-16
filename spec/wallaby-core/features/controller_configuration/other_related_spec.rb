# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ResourcesController do
  describe '.max_text_length' do
    it 'returns nil' do
      expect(described_class.try(:max_text_length)).to eq Wallaby::DEFAULT_MAX
    end

    context 'when subclasses' do
      let(:application_controller) do
        stub_const('Admin::ApplicationController', base_class_from(described_class))
      end

      it 'returns its max_text_length' do
        expect(application_controller.try(:max_text_length)).to eq Wallaby::DEFAULT_MAX
      end

      context 'when application controller has its own max_text_length' do
        let(:application_value) { 10 }

        it 'returns its max_text_length' do
          application_controller.try :max_text_length=, application_value
          expect(application_controller.try(:max_text_length)).to eq application_value
        end
      end

      context 'when application controller set max_text_length to an invalid value' do
        let(:application_value) { 'invalid_value' }

        it 'raises error' do
          expect { application_controller.try :max_text_length=, application_value }.to raise_error ArgumentError
        end
      end
    end
  end

  describe '.page_size' do
    it 'returns nil' do
      expect(described_class.try(:page_size)).to eq Wallaby::DEFAULT_PAGE_SIZE
    end

    context 'when subclasses' do
      let(:application_controller) do
        stub_const('Admin::ApplicationController', base_class_from(described_class))
      end

      it 'returns its page_size' do
        expect(application_controller.try(:page_size)).to eq Wallaby::DEFAULT_PAGE_SIZE
      end

      context 'when application controller has its own page_size' do
        let(:application_value) { 10 }

        it 'returns its page_size' do
          application_controller.try :page_size=, application_value
          expect(application_controller.try(:page_size)).to eq application_value
        end
      end

      context 'when application controller set page_size to an invalid value' do
        let(:application_value) { 'invalid_value' }

        it 'raises error' do
          expect { application_controller.try :page_size=, application_value }.to raise_error ArgumentError
        end
      end
    end
  end

  describe '.sorting_strategy' do
    it 'returns nil' do
      expect(described_class.try(:sorting_strategy)).to eq :multiple
    end

    context 'when subclasses' do
      let(:application_controller) do
        stub_const('Admin::ApplicationController', base_class_from(described_class))
      end

      it 'returns its sorting_strategy' do
        expect(application_controller.try(:sorting_strategy)).to eq :multiple
      end

      context 'when application controller has its own sorting_strategy' do
        let(:application_value) { :single }

        it 'returns its sorting_strategy' do
          application_controller.try :sorting_strategy=, application_value
          expect(application_controller.try(:sorting_strategy)).to eq application_value
        end
      end

      context 'when application controller set sorting_strategy to an invalid value' do
        let(:application_value) { 'invalid_value' }

        it 'raises error' do
          expect { application_controller.try :sorting_strategy=, application_value }.to raise_error ArgumentError
        end
      end
    end
  end
end
