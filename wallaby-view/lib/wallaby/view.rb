# frozen_string_literal: true

require 'wallaby/view/version'
require 'wallaby/view/action_viewable'
require 'wallaby/view/themeable'
require 'wallaby/view/custom_lookup_context'
require 'wallaby/view/custom_prefixes'

module Wallaby # :nodoc:
  # To extend Rails prefixes and improve lookup performance.
  #
  # For example, include {Wallaby::View} module in the controller:
  #
  # ```
  # # app/controllers/application_controller
  # class ApplicationController < ActionController::Base
  #   include Wallaby::View
  # end
  # ```
  module View
    extend ActiveSupport::Concern

    COMMA = ',' # :nodoc:
    EMPTY_STRING = '' # :nodoc:
    DOT_RB = '.rb' # :nodoc:
    SLASH = '/' # :nodoc:
    EQUAL = '=' # :nodoc:
    UNDERSCORE = '_' # :nodoc:

    include ActionViewable
    include Themeable

    included do
      # NOTE: Basically, it renames the methods so that it is possible
      # to access the original methods after overriding them:
      alias_method :original_lookup_context, :lookup_context
      alias_method :original_prefixes, :_prefixes
      alias_method :lookup_context, :override_lookup_context
      alias_method :_prefixes, :override_prefixes
    end
  end
end
