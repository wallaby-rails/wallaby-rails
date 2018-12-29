require 'rails_helper'

describe 'GlobalDecorator', type: :request do
  before do
    stub_const 'GlobalDecorator', (Class.new Wallaby::ResourceDecorator do
      def to_label
        'Using GlobalDecorator'
      end
    end)

    Wallaby.configuration.mapping.resource_decorator = GlobalDecorator
  end

  it 'uses the configured resources decorator instead of ResourcesDecorator' do
    picture = Picture.create! name: 'a picture'
    get "/admin/pictures/#{picture.id}"
    expect(response).to be_successful
    expect(response.body).to include 'Using GlobalDecorator'
  end
end
