require 'rails_helper'

describe Wallaby::Sorting::LinkBuilder, :current_user, type: :helper do
  let(:model_decorator) { Wallaby::ActiveRecord.model_decorator.new Product }
  let(:params) { parameters.permit(:sort, :q) }
  subject { described_class.new model_decorator, params, helper }

  describe '#build' do
    it 'returns a sort link when field is origin and not associations' do
      expect(subject.build('tags')).to eq 'Tags'
      expect(subject.build('id')).to eq '<a title="Product" href="/admin/products?sort=id+asc">Id</a>'
    end

    it 'returns a sort link even when field is not origin but sort_field_name is set' do
      model_decorator.index_fields['model'] = { label: 'Model', is_origin: false, is_association: false, sort_field_name: 'id' }

      expect(subject.build('model')).to eq '<a title="Product" href="/admin/products?sort=id+asc">Model</a>'
    end

    it 'includes other params' do
      params[:q] = 'search keyword'
      expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products?q=search+keyword&amp;sort=name+asc">Name</a>'
    end

    it 'returns a sorting hash' do
      expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products?sort=name+asc">Name</a>'
      subject.instance_variable_set '@current_sort', nil
      subject.instance_variable_set '@next_builder', nil

      params[:sort] = 'name asc'
      expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products?sort=name+desc">Name</a>'
      subject.instance_variable_set '@current_sort', nil
      subject.instance_variable_set '@next_builder', nil

      params[:sort] = 'name desc'
      expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products">Name</a>'
      subject.instance_variable_set '@current_sort', nil
      subject.instance_variable_set '@next_builder', nil

      model_decorator.index_fields[:updated_at] = { sort_field_name: 'updated_at' }
      params[:sort] = 'name desc,updated_at asc'
      expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products?sort=updated_at+asc">Name</a>'
      expect(subject.build(:updated_at)).to eq '<a title="Product" href="/admin/products?sort=name+desc%2Cupdated_at+desc">Updated at</a>'
      subject.instance_variable_set '@current_sort', nil
      subject.instance_variable_set '@next_builder', nil

      params[:sort] = 'name desc,updated_at desc'
      expect(subject.build(:name)).to eq '<a title="Product" href="/admin/products?sort=updated_at+desc">Name</a>'
      expect(subject.build(:updated_at)).to eq '<a title="Product" href="/admin/products?sort=name+desc">Updated at</a>'
    end
  end

  describe '#current_sort' do
    it 'returns a sorting hash' do
      params[:sort] = 'name asc'
      expect(subject.current_sort).to eq 'name' => 'asc'
      subject.instance_variable_set '@current_sort', nil

      params[:sort] = 'name asc,updated_at desc'
      expect(subject.current_sort).to eq 'name' => 'asc', 'updated_at' => 'desc'
      subject.instance_variable_set '@current_sort', nil

      params[:sort] = 'name  asc , updated_at  desc'
      expect(subject.current_sort).to eq 'name' => 'asc', 'updated_at' => 'desc'
      subject.instance_variable_set '@current_sort', nil
    end
  end
end
