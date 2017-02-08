require 'rails_helper'

describe 'Resources pages using mysql table' do
  let(:string) { 'Vincent van Gogh' }
  let(:model_class) { AllMysqlType }

  describe '#index' do
    let!(:record) { model_class.create!({ string: string }) }

    it 'renders collections' do
      get '/admin/all_mysql_types'
      expect(response).to be_successful
      expect(response).to render_template :index
      expect(response.body).to include string

      get '/admin/all_mysql_types?q=van&sort=string%20desc'
      expect(response).to be_successful
      expect(response).to render_template :index
      expect(response.body).to include string

      get '/admin/all_mysql_types?q=unknown'
      expect(response).to be_successful
      expect(response).to render_template :index
      expect(response.body).not_to include string
    end
  end

  describe '#show' do
    let!(:record) { model_class.create!({ string: string }) }
    it 'renders show' do
      get "/admin/all_mysql_types/#{ record.id }"
      expect(response).to be_successful
      expect(response).to render_template :show
      expect(response.body).to include string
    end
  end

  describe '#new' do
    it 'renders show' do
      get '/admin/all_mysql_types/new'
      expect(response).to be_successful
      expect(response).to render_template :new
      expect(response.body).to include "name=\"all_mysql_type[string]\""
    end
  end

  describe '#create' do
    it 'creates the record' do
      expect(model_class.count).to eq 0
      post '/admin/all_mysql_types', params: { all_mysql_type: { string: string } }
      expect(response).to redirect_to '/admin/all_mysql_types'
      expect(model_class.count).to eq 1
      expect(model_class.first.string).to eq string
    end

    context 'when form error exists' do
      let(:string) { 'Vincent van Gogh' }
      let(:model_class) { Picture }

      it 'renders form and show error' do
        post '/admin/pictures', params: { picture: { string: string } }
        expect(response).to render_template :new
        expect(response.body).to match "can't be blank"
      end
    end
  end

  describe '#edit' do
    let!(:record) { model_class.create!({ string: string }) }
    it 'renders edit' do
      get "/admin/all_mysql_types/#{ record.id }/edit"
      expect(response).to be_successful
      expect(response).to render_template :edit
      expect(response.body).to include "value=\"#{ string }\""
    end
  end

  describe '#update' do
    let!(:record) { model_class.create!({ string: string }) }
    it 'updates the record' do
      a_string = 'Claude Monet'
      put "/admin/all_mysql_types/#{ record.id }", params: { all_mysql_type: { string: a_string } }
      expect(response).to redirect_to "/admin/all_mysql_types/#{ record.id }"
      expect(record.reload.string).to eq a_string
    end

    context 'when form error exists' do
      let(:string) { 'Vincent van Gogh' }
      let(:model_class) { Picture }
      let!(:record) { model_class.create!({ name: string }) }

      it 'renders form and show error' do
        put "/admin/pictures/#{ record.id }", params: { picture: { name: '' } }
        expect(response).to render_template :edit
        expect(response.body).to match "can't be blank"
      end
    end
  end

  describe '#destroy' do
    let!(:record) { model_class.create!({ string: string }) }
    it 'destroys the record' do
      expect(model_class.count).to eq 1
      delete "/admin/all_mysql_types/#{ record.id }"
      expect(response).to redirect_to "/admin/all_mysql_types"
      expect(model_class.count).to eq 0
    end
  end
end
