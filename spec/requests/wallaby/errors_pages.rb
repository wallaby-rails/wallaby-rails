require 'rails_helper'

describe 'Errors pages' do
  Wallaby::ERRORS.each do |status|
    code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]

    describe status do
      get "/admin/#{status}"
      expect(response.status).to eq code
      expect(response.body).to include view.t("http_errors.#{status}")
    end

    describe code do
      get "/admin/#{code}"
      expect(response.status).to eq code
      expect(response.body).to include view.t("http_errors.#{status}")
    end
  end
end
