# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout 'other_application'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # SECURITY: this dummy app exists only to exercise Wallaby's own behavior in
  # the test suite, so it deliberately opts out of authentication. Wallaby is
  # fail-closed and would otherwise reject every request. Do NOT copy this into
  # a real application: define a real `authenticate_wallaby_user!` instead.
  def authenticate_wallaby_user!
    true
  end

  def prefixes
    render json: _prefixes
  end
end
