# frozen_string_literal: true

module Wallaby
  # Wallaby application helper
  module ApplicationHelper
    include ConfigurationHelper
    include Configurable
    include Engineable
    include Urlable

    # Override original #form_for method to provide default form builder
    # @param record [ActiveRecord::Base, String, Symbol]
    # @param options [Hash]
    def form_for(record, options = {}, &block)
      options[:builder] ||= FormBuilder
      super
    end

    # I18n transaltion just for Wallaby
    # @param key
    # @param options [Hash]
    # @return [String] transaltion for given key
    def wt(key, options = {})
      Locale.t key, { translator: method(:t) }.merge(options)
    end
  end
end
