require 'rails_helper'

describe Wallaby::LinksHelper, :current_user do
  describe '#sort_hash' do
    it 'returns a sorting hash' do
      helper.params[:sort] = 'name asc'
      expect(helper.sort_hash).to eq 'name' => 'asc'
      helper.instance_variable_set '@sort_hash', nil

      helper.params[:sort] = 'name asc,updated_at desc'
      expect(helper.sort_hash).to eq 'name' => 'asc', 'updated_at' => 'desc'
      helper.instance_variable_set '@sort_hash', nil

      helper.params[:sort] = 'name  asc , updated_at  desc'
      expect(helper.sort_hash).to eq 'name' => 'asc', 'updated_at' => 'desc'
      helper.instance_variable_set '@sort_hash', nil
    end
  end

  describe '#new_sort_param' do
    it 'does not change either params or sort_hash' do
      expect(helper.sort_hash).to eq({})
      expect(helper.new_sort_param :name).to eq sort: 'name asc'
      expect(helper.sort_hash).to eq({})
      expect(helper.params).to eq({})
    end

    it 'includes other params' do
      helper.params[:q] = 'search keyword'
      expect(helper.new_sort_param :name).to eq q: 'search keyword', sort: 'name asc'
    end

    it 'returns a sorting hash' do
      expect(helper.params).to eq({})
      expect(helper.new_sort_param :name).to eq sort: 'name asc'
      helper.instance_variable_set '@sort_hash', nil

      helper.params[:sort] = 'name asc'
      expect(helper.new_sort_param :name).to eq sort: 'name desc'
      helper.instance_variable_set '@sort_hash', nil

      helper.params[:sort] = 'name desc'
      expect(helper.new_sort_param :name).to eq({})
      helper.instance_variable_set '@sort_hash', nil

      helper.params[:sort] = 'name desc,updated_at asc'
      expect(helper.new_sort_param :name).to eq sort: 'updated_at asc'
      expect(helper.new_sort_param :updated_at).to eq sort: 'name desc,updated_at desc'
      helper.instance_variable_set '@sort_hash', nil

      helper.params[:sort] = 'name desc,updated_at desc'
      expect(helper.new_sort_param :name).to eq sort: 'updated_at desc'
      expect(helper.new_sort_param :updated_at).to eq sort: 'name desc'
    end
  end

  describe '#sort_class' do
    it 'returns a sorting class' do
      expect(helper.sort_class :name).to be_nil
      helper.instance_variable_set '@sort_hash', nil

      helper.params[:sort] = 'name asc'
      expect(helper.sort_class :name).to eq 'asc'
      helper.instance_variable_set '@sort_hash', nil

      helper.params[:sort] = 'name desc'
      expect(helper.sort_class :name).to eq 'desc'
      helper.instance_variable_set '@sort_hash', nil

      helper.params[:sort] = 'name desc,updated_at asc'
      expect(helper.sort_class :updated_at).to eq 'asc'
      helper.instance_variable_set '@sort_hash', nil

      helper.params[:sort] = 'name desc,updated_at desc'
      expect(helper.sort_class :updated_at).to eq 'desc'
    end
  end
end
