require 'rails_helper'

describe Wallaby::HomeController do
  describe '#healthy' do
    it 'returns healthy' do
      get :healthy
      expect(response.body).to eq 'healthy'

      get :healthy, format: :json
      expect(response.body).to eq 'healthy'
    end
  end
end
