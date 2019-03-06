require 'rails_helper'

describe 'non admin usage' do
  let(:model_class) { Picture }

  describe 'resources records' do
    it 'lists collection' do
      record1 = model_class.create name: 'record1'
      record2 = model_class.create name: 'record2'
      record3 = model_class.create name: 'record3'
      http :get, '/pictures'
      expect(response).to be_successful
      expect(response).to render_template :index
      expect(response.body).to include record1.name
      expect(response.body).to include record2.name
      expect(response.body).to include record3.name
    end

    it 'shows resource' do
      record = model_class.create name: 'beautiful'
      http :get, "/pictures/#{record.id}"
      expect(response).to be_successful
      expect(response).to render_template :show
      expect(response.body).to include record.name
    end

    it 'shows new form' do
      http :get, '/pictures/new'
      expect(response).to be_successful
      expect(response).to render_template :new
    end

    it 'creates resource' do
      expect(model_class.count).to eq 0
      http :post, '/pictures', params: { picture: { name: 'beautiful' } }
      record = model_class.last
      expect(response).to redirect_to "/pictures/#{record.id}"
      expect(flash[:notice]).to eq 'Picture was successfully created.'
      expect(model_class.count).to eq 1
      expect(record.name).to eq 'beautiful'
    end

    context 'when params is missing' do
      it 'shows error' do
        http :post, '/pictures'
        expect(response).to have_http_status :bad_request
        expect(response).to render_template 'wallaby/error'
      end
    end

    context 'when name is missing' do
      it 'shows error' do
        http :post, '/pictures', params: { picture: { test: 'test' } }
        expect(response).to render_template :new
        expect(model_class.count).to eq 0
      end
    end

    it 'shows new form' do
      record = model_class.create name: 'beautiful'
      http :get, "/pictures/#{record.id}/edit"
      expect(response).to be_successful
      expect(response).to render_template :edit
    end

    it 'updates resource' do
      record = model_class.create name: 'beautiful'
      http :put, "/pictures/#{record.id}", params: { picture: { name: 'splendid' } }
      expect(response).to redirect_to "/pictures/#{record.id}"
      expect(flash[:notice]).to eq 'Picture was successfully updated.'
    end

    context 'when params is missing' do
      it 'shows error' do
        record = model_class.create name: 'beautiful'
        http :put, "/pictures/#{record.id}"
        expect(response).to have_http_status :bad_request
        expect(response).to render_template 'wallaby/error'
      end
    end

    context 'when name is missing' do
      it 'shows error' do
        record = model_class.create name: 'beautiful'
        http :put, "/pictures/#{record.id}", params: { picture: { name: '' } }
        expect(response).to render_template :edit
        expect(record.reload.name).to eq 'beautiful'
      end
    end

    it 'deletes resource' do
      record = model_class.create name: 'beautiful'
      http :delete, "/pictures/#{record.id}"
      expect(response).to redirect_to '/pictures'
    end
  end
end
