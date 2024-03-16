# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  context "with #{Wallaby::ResourcesConcern}" do
    it 'has the following alias methods' do
      %i[index! new! create! show! edit! update! destroy!].each do |method_id|
        expect(controller).to be_respond_to method_id
      end
    end
  end

  context "with #{Wallaby::Resourcable}" do
    it 'has the following alias methods' do
      %i[collection! resource!].each do |method_id|
        expect(controller).to be_respond_to method_id
      end
    end
  end
end
