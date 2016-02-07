require 'rails_helper'

describe Wallaby::CoreController do
  describe '#status' do
    it 'returns healthy' do
      get :status
      expect(response.body).to eq 'healthy'

      get :status, format: :json
      expect(response.body).to eq 'healthy'
    end
  end
end
