# frozen_string_literal: true

require 'rails_helper'

describe 'prefix options', type: :request do
  context 'with backend custom' do
    specify do
      http(:get, prefix_options_backend_custom_path)

      expect(response).to be_successful
      expect(page_json).to eq({ 'prefixes' => ['form'] })
    end
  end

  context 'with backend custom child' do
    specify do
      http(:get, prefix_options_backend_custom_child_path)

      expect(response).to be_successful
      expect(page_json).to eq({ 'prefixes' => ['form'] })
    end
  end

  context 'with backend custom grand child' do
    specify do
      http(:get, prefix_options_backend_custom_grand_child_path)

      expect(response).to be_successful
      expect(page_json).to eq({ 'prefixes' => ['form'], 'index' => 'grand' })
    end
  end
end
