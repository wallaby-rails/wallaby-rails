# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout 'other_application'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def prefixes
    render json: _prefixes.to_json
  end
end
