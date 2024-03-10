# frozen_string_literal: true

# NOTE: We need to require the following rails engines
# so that the main app could pick up the assets from these engines
# even if they don't appear in the `Gemfile`
require 'csv'
require 'jbuilder'
require 'sprockets/railtie'
