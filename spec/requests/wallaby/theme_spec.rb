# frozen_string_literal: true
require 'rails_helper'

describe 'blog that uses theme' do
  describe 'post list page' do
    it 'renders the theme' do
      Blog.create subject: 'this is a title'
      http :get, '/blogs'
      expect(response).to be_successful
      expect(response).to render_template 'layouts/simple_blog_theme'
      expect(response).to render_template 'simple_blog_theme/index'
    end
  end

  describe 'post show page' do
    it 'renders the theme' do
      blog = Blog.create subject: 'this is a title'
      http :get, "/blogs/#{blog.id}"
      expect(response).to be_successful
      expect(response).to render_template 'layouts/simple_blog_theme'
      expect(response).to render_template 'simple_blog_theme/show'
      expect(response.body).to include 'this is a title'
    end
  end
end
