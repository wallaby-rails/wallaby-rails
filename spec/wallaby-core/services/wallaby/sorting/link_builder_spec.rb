# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Sorting::LinkBuilder, :wallaby_user, type: :helper do
  subject { described_class.new model_decorator, params, helper, strategy }

  let(:model_decorator) { Wallaby::ActiveRecord.model_decorator.new Product }
  let(:params) { parameters!(action: 'index', resources: 'products') }
  let(:strategy) { nil }

  describe '#build' do
    it 'returns a sort link for non-association field' do
      expect(subject.build('id')).to eq '<a title="Product" href="/admin/products?sort=id+asc">Id</a>'
    end

    it 'returns text for assoication' do
      expect(subject.build('tags')).to eq 'Tags'
    end

    it 'returns a sort link for custom field' do
      model_decorator.index_fields['model'] = { label: 'Model', is_association: false, sort_field_name: 'id' }

      expect(subject.build('model')).to eq '<a title="Product" href="/admin/products?sort=id+asc">Model</a>'
    end

    it 'includes other params in the link' do
      params[:q] = 'search keyword'
      expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products?q=search+keyword&amp;sort=name+asc">Name</a>'
    end

    it 'returns a sort link' do
      expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products?sort=name+asc">Name</a>'
    end

    it 'returns a sort link for name asc' do
      params[:sort] = 'name asc'
      expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products?sort=name+desc">Name</a>'
    end

    it 'returns a sort link for name desc' do
      params[:sort] = 'name desc'
      expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products">Name</a>'
    end

    it 'returns a sort link for name desc and published_at asc' do
      model_decorator.index_fields[:published_at] = { sort_field_name: 'published_at' }
      params[:sort] = 'name desc,published_at asc'
      expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products?sort=published_at+asc">Name</a>'
      expect(subject.build(:published_at)).to eq '<a title="Product" href="/admin/products?sort=name+desc%2Cpublished_at+desc">Published at</a>'
    end

    it 'returns a sort link for name desc and published_at desc' do
      params[:sort] = 'name desc,published_at desc'
      expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products?sort=published_at+desc">Name</a>'
      expect(subject.build(:published_at)).to eq '<a title="Product" href="/admin/products?sort=name+desc">Published at</a>'
    end

    context 'when sort_disabled is set' do
      it 'returns a sort link for non-association field' do
        model_decorator.index_fields[:id][:sort_disabled] = true
        expect(subject.build('id')).to eq 'Id'
      end

      it 'returns text for assoication' do
        model_decorator.index_fields[:tags][:sort_disabled] = true
        expect(subject.build('tags')).to eq 'Tags'
      end

      it 'returns a sort link for custom field' do
        model_decorator.index_fields[:model] = { label: 'Model', is_association: false, sort_field_name: 'id' }
        model_decorator.index_fields[:model][:sort_disabled] = true

        expect(subject.build('model')).to eq 'Model'
      end
    end

    context 'when strategy is single' do
      let(:strategy) { :single }

      it 'returns a sort link' do
        expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products?sort=name+asc">Name</a>'
      end

      it 'returns a sort link for name asc' do
        params[:sort] = 'name asc'
        expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products?sort=name+desc">Name</a>'
      end

      it 'returns a sort link for name desc' do
        params[:sort] = 'name desc'
        expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products">Name</a>'
      end

      it 'returns a sort link for name desc and published_at' do
        params[:sort] = 'name desc'
        expect(subject.build(:published_at)).to eq '<a title="Product" href="/admin/products?sort=published_at+asc">Published at</a>'
      end

      it 'returns a sort link for name desc and published_at asc' do
        model_decorator.index_fields[:published_at] = { sort_field_name: 'published_at' }
        params[:sort] = 'name desc,published_at asc'
        expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products">Name</a>'
        expect(subject.build(:published_at)).to eq '<a title="Product" href="/admin/products?sort=published_at+desc">Published at</a>'
      end

      it 'returns a sort link for name desc and published_at desc' do
        params[:sort] = 'name desc,published_at desc'
        expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products">Name</a>'
        expect(subject.build(:published_at)).to eq '<a title="Product" href="/admin/products">Published at</a>'
      end
    end
  end

  describe '#current_sort' do
    it 'returns a sorting hash' do
      params[:sort] = 'name asc'
      expect(subject.current_sort).to eq 'name' => 'asc'
    end

    it 'returns a sorting hash for name asc and published_at asc' do
      params[:sort] = 'name asc,published_at desc'
      expect(subject.current_sort).to eq 'name' => 'asc', 'published_at' => 'desc'
    end

    it 'returns a sorting hash for name asc and published_at desc' do
      params[:sort] = 'name  asc , published_at  desc'
      expect(subject.current_sort).to eq 'name' => 'asc', 'published_at' => 'desc'
    end
  end
end
