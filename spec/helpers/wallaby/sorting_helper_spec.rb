require 'rails_helper'

describe Wallaby::SortingHelper, :current_user do
  describe '#sort_link' do
    let(:model_decorator) { Wallaby::ActiveRecord.model_decorator.new Product }

    it 'returns a sort link when field is origin and not associations' do
      expect(helper.sort_link('tags', model_decorator)).to eq 'Tags'
      expect(helper.sort_link('id', model_decorator)).to eq '<a href="/admin/products?sort=id+asc">Id</a>'
    end

    it 'returns a sort link even when field is not origin but sort_field_name is set' do
      model_decorator.index_fields['model'] = { label: 'Model', is_origin: false, is_association: false, sort_field_name: 'id' }

      expect(helper.sort_link('model', model_decorator)).to eq '<a href="/admin/products?sort=id+asc">Model</a>'
    end
  end

  describe '#current_sort' do
    it 'returns a sorting hash' do
      helper.params[:sort] = 'name asc'
      expect(helper.current_sort).to eq 'name' => 'asc'
      helper.instance_variable_set '@current_sort', nil

      helper.params[:sort] = 'name asc,updated_at desc'
      expect(helper.current_sort).to eq 'name' => 'asc', 'updated_at' => 'desc'
      helper.instance_variable_set '@current_sort', nil

      helper.params[:sort] = 'name  asc , updated_at  desc'
      expect(helper.current_sort).to eq 'name' => 'asc', 'updated_at' => 'desc'
      helper.instance_variable_set '@current_sort', nil
    end
  end

  describe '#next_sort_param' do
    it 'does not change either params or current_sort' do
      expect(helper.next_sort_param(:name)).to eq parameters sort: 'name asc'
      expect { helper.next_sort_param :name }.not_to(change { helper.params })
    end

    it 'includes other params' do
      helper.params[:q] = 'search keyword'
      expect(helper.next_sort_param(:name)).to eq parameters q: 'search keyword', sort: 'name asc'
    end

    it 'returns a sorting hash' do
      expect(helper.params).to eq(parameters)
      expect(helper.next_sort_param(:name)).to eq parameters sort: 'name asc'
      helper.instance_variable_set '@current_sort', nil
      helper.instance_variable_set '@next_builder', nil

      helper.params[:sort] = 'name asc'
      expect(helper.next_sort_param(:name)).to eq parameters sort: 'name desc'
      helper.instance_variable_set '@current_sort', nil
      helper.instance_variable_set '@next_builder', nil

      helper.params[:sort] = 'name desc'
      expect(helper.next_sort_param(:name)).to eq(parameters)
      helper.instance_variable_set '@current_sort', nil
      helper.instance_variable_set '@next_builder', nil

      helper.params[:sort] = 'name desc,updated_at asc'
      expect(helper.next_sort_param(:name)).to eq parameters sort: 'updated_at asc'
      expect(helper.next_sort_param(:updated_at)).to eq parameters sort: 'name desc,updated_at desc'
      helper.instance_variable_set '@current_sort', nil
      helper.instance_variable_set '@next_builder', nil

      helper.params[:sort] = 'name desc,updated_at desc'
      expect(helper.next_sort_param(:name)).to eq parameters sort: 'updated_at desc'
      expect(helper.next_sort_param(:updated_at)).to eq parameters sort: 'name desc'
    end
  end

  describe '#sort_class' do
    it 'returns a sorting class' do
      expect(helper.sort_class(:name)).to be_nil
      helper.instance_variable_set '@current_sort', nil

      helper.params[:sort] = 'name asc'
      expect(helper.sort_class(:name)).to eq 'asc'
      helper.instance_variable_set '@current_sort', nil

      helper.params[:sort] = 'name desc'
      expect(helper.sort_class(:name)).to eq 'desc'
      helper.instance_variable_set '@current_sort', nil

      helper.params[:sort] = 'name desc,updated_at asc'
      expect(helper.sort_class(:updated_at)).to eq 'asc'
      helper.instance_variable_set '@current_sort', nil

      helper.params[:sort] = 'name desc,updated_at desc'
      expect(helper.sort_class(:updated_at)).to eq 'desc'
    end
  end
end
