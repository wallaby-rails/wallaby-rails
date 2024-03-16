# frozen_string_literal: true

class BaseController < ApplicationController
  include Wallaby::ResourcesConcern
  base_class!
end
