require 'rails_helper'

describe Wallaby::LinksHelper, :current_user do
  describe '#sort_param' do
    it 'returns a sorting hash' do
      expect(helper.sort_param :name).to eq sort: 'name asc'
      helper.params[:sort] = 'name asc'
      expect(helper.sort_param :name).to eq sort: 'name desc'
      helper.params[:sort] = 'name desc'
      expect(helper.sort_param :name).to eq Hash.new
      expect(helper.sort_param :updated_at).to eq sort: 'name desc,updated_at asc'
      helper.params[:sort] = 'name desc,updated_at asc'
      expect(helper.sort_param :updated_at).to eq sort: 'name desc,updated_at desc'
      helper.params[:sort] = 'name desc,updated_at desc'
      expect(helper.sort_param :updated_at).to eq sort: 'name desc'
    end
  end

  describe '#sort_class' do
    it 'returns a sorting class' do
      expect(helper.sort_class :name).to be_nil
      helper.params[:sort] = 'name asc'
      expect(helper.sort_class :name).to eq 'asc'
      helper.params[:sort] = 'name desc'
      expect(helper.sort_class :name).to eq 'desc'
      helper.params[:sort] = 'name desc,updated_at asc'
      expect(helper.sort_class :updated_at).to eq 'asc'
      helper.params[:sort] = 'name desc,updated_at desc'
      expect(helper.sort_class :updated_at).to eq 'desc'
    end
  end
end
