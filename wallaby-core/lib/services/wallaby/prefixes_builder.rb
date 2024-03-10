# frozen_string_literal: true

module Wallaby
  # (see #execute)
  class PrefixesBuilder
    include ActiveModel::Model

    delegate :controller_path, to: :controller_class

    # @!attribute prefixes
    # @return [Array<String>]
    attr_accessor :prefixes
    # @!attribute resources_name
    # @return [String, nil]
    attr_accessor :resources_name
    # @!attribute script_name
    # @return [String]
    attr_accessor :script_name
    # @!attribute controller_class
    # @return [String]
    attr_accessor :controller_class

    # To extend prefixes to be able to look up the directory
    # even if the custom controller doesn't not exist
    # @return [Array<String>] modified prefixes
    def execute
      return prefixes_dup unless resourceful?
      return prefixes_dup if possible_resources_path == controller_path

      prefixes_dup.insert(
        prefixes_dup.index(controller_path) + offset,
        possible_resources_path
      )
    end

    protected

    # @return [Array<String>]
    def prefixes_dup
      @prefixes_dup ||= prefixes.dup
    end

    # @return [Boolean]
    def resourceful?
      resources_name.present?
    end

    # @return [Boolean]
    def based_controller?
      controller_class.model_class.blank?
    end

    # @return [Integer] 0 or 1
    def offset
      based_controller? ? 0 : 1
    end

    # @return [String]
    def possible_resources_path
      [script_path, resources_path].compact.join(SLASH)
    end

    # @return [String, nil]
    def resources_path
      resources_name.try(:gsub, COLONS, SLASH)
    end

    # @return [String, nil]
    def script_path
      script_name.try(:[], 1..-1)
    end
  end
end
