# frozen_string_literal: true

class CollectionsController < ActionController::Base
  include Wallaby::View

  def prefixes
    render json: _prefixes
  end
end
