# frozen_string_literal: true

module Wallaby
  # A simple wrapper so that all fields (index/show/form and other fields appear before itself)
  # can be set in one-line.
  #
  # @example set type for name to `'string'` in decorator
  #   class ProductDecorator < ApplicationDecorator
  #     some_fields[:id][:sort_disabled] = true
  #     all_fields[:name][:type] = 'string'
  #     # index_fields[:name][:type] => 'string'
  #     # show_fields[:name][:type] => 'string'
  #     # form_fields[:name][:type] => 'string'
  #     # some_fields[:name][:type] => 'string'
  #   end
  class AllFields
    def initialize(decorator)
      @decorator = decorator
      @keys = []
    end

    # @param key [Symbol, String]
    # @return [AllFields] self
    def [](key)
      @keys << key
      self
    end

    # Set value for given keys
    # @param last_key [Symbol, String]
    # @param value [Object]
    # @return [Object] value
    def []=(last_key, value)
      all_fields.each do |fields_method|
        last = @keys.reduce(@decorator.try(fields_method)) do |metadata, key|
          metadata.try :[], key
        end
        last.try :[]=, last_key, value
      end

      @keys = []
      value # rubocop:disable Lint/Void
    end

    protected

    def all_fields
      existing_fields + possible_fields_from_instance_variables
    end

    def existing_fields
      %w[index_fields show_fields form_fields]
    end

    def possible_fields_from_instance_variables
      @decorator
        .model_decorator.instance_variables
        .map(&:to_s)
        .grep(/\A@[a-zA-Z]\w*_fields\Z/)
        .map { |s| s[1..] }
    end
  end
end
