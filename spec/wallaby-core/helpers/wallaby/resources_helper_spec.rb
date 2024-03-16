# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ResourcesHelper, :wallaby_user, type: :helper do
  describe '#decorate' do
    context 'when single object' do
      it 'returns a decorator' do
        resource = Product.new
        expect(helper.decorate(resource)).to be_a Wallaby::ResourceDecorator
      end

      context 'when decorated' do
        it 'returns the same decorated' do
          resource = Product.new
          decorated = helper.decorate(resource)
          expect(helper.decorate(decorated)).to be_a Wallaby::ResourceDecorator
          expect(helper.decorate(decorated)).to eq decorated
        end
      end
    end

    context 'when resources is enumerable' do
      before do
        AllPostgresType.create string: 'string'
      end

      let(:resources) { AllPostgresType.where(nil) }

      it 'returns decorators' do
        expect(helper.decorate(resources)).to be_an Array
        expect(helper.decorate(resources)).to all be_a Wallaby::ResourceDecorator
      end

      context 'when decorated' do
        it 'returns the same decorated' do
          decorated = helper.decorate(resources)
          expect(helper.decorate(decorated)).to all be_a Wallaby::ResourceDecorator
          expect(helper.decorate(decorated)).to eq decorated
        end
      end
    end

    context 'when resources is not decoratable' do
      let(:resources) { Time.zone.now }

      it 'returns decorators' do
        expect(helper.decorate(resources)).to be_an Time
      end
    end
  end

  describe '#extract' do
    let(:resource) { Product.new }

    it 'returns original resource' do
      new_resource = Wallaby::ResourceDecorator.new resource
      expect(helper.extract(new_resource)).to eq resource
    end

    context 'when resource is the origin' do
      it 'returns itself' do
        expect(helper.extract(resource)).to eq resource
      end
    end
  end

  describe '#show_title' do
    it 'returns a title for decorated resources' do
      resource = Product.new name: 'example'
      decorated = helper.decorate resource
      expect(helper.show_title(decorated)).to eq 'Product: example'
    end

    context 'when it is not decorated' do
      it 'raises error' do
        resource = Product.new name: 'example'
        expect { helper.show_title resource }.to raise_error ArgumentError
      end
    end
  end
end
