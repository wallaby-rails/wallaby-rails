# frozen_string_literal: true

class BlogsController < ApplicationController
  include Wallaby::ResourcesConcern
  self.theme_name = 'simple_blog_theme'
end
