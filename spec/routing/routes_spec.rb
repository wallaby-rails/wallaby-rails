require 'rails_helper'

describe 'routing' do
  routes { Wallaby::Engine.routes }
  it 'routes to the general resourceful routes' do
    expect(get: resources_path('posts')).to be_routable
  end
end