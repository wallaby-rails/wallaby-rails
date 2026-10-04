# frozen_string_literal: true

require 'rails_helper'

# Security regression specs for parameter filtering.
#
# Covers OWASP A09: credential/secret parameters must be filtered from logs.
# See the audit finding H4.
describe 'filter parameter logging' do
  let(:filters) { Rails.application.config.filter_parameters }

  it 'filters passwords' do
    expect(filters).to include :password
  end

  it 'filters common credential and secret parameters' do
    expect(filters).to include(
      :password_confirmation, :secret, :token, :api_key, :access_token, :private_key
    )
  end
end
