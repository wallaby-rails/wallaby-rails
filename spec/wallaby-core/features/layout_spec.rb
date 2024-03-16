# frozen_string_literal: true

require 'rails_helper'

describe '._layout' do
  it 'returns wallaby/resources' do
    expect(ApplicationController._layout).to eq 'other_application'
    expect(Wallaby::ResourcesController._layout).to eq 'wallaby/resources'
  end

  context 'when controller only includes ResourcesConcern' do
    it "returns application's layout" do
      expect(OrdersController._layout).to eq 'wallaby/resources'
    end
  end

  context 'when controller inherits from ResourcesController' do
    it 'returns wallaby/resources' do
      expect(CategoriesController._layout).to eq 'wallaby/resources'
    end
  end

  context 'when controller inherits from ResourcesController, but theme is set' do
    it 'returns other_application' do
      expect(BlogsController._layout).to eq 'simple_blog_theme'
    end
  end
end
