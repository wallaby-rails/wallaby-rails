module Wallaby
  # To extend prefixes to provide more possibility
  class PrefixesBuilder
    # @param origin_prefixes [Array<string>] a list of all the origin prefixes
    # @param action_name [String] action name
    # @param resources_name [String] resources name
    # @param script_name [String] script name
    # @param theme_name [String] theme name
    def self.build(origin_prefixes:, action_name:, resources_name:, script_name:, theme_name:)
      new(
        origin_prefixes: origin_prefixes,
        action_name: action_name,
        resources_name: resources_name,
        script_name: script_name,
        theme_name: theme_name
      ).send :build
    end

    private

    # Constructor
    def initialize(origin_prefixes:, action_name:, resources_name:, script_name:, theme_name:)
      @origin_prefixes = origin_prefixes
      @action_name = action_name
      @resources_name = resources_name
      @script_name = script_name
      @theme_name = theme_name
    end

    # @return [Array<String>] prefixes
    def build
      prefixes = minimal_prefixes
      prefixes.unshift mounted_prefix unless prefixes.include? resources_path
      prefixes.uniq.compact.each_with_object([]) do |prefix, result|
        result << "#{prefix}/#{suffix}" << prefix
      end
    end

    # @return [Array<String>] prefixes starting from wallaby controller path
    def minimal_prefixes
      index = @origin_prefixes.index ResourcesController.controller_path
      @origin_prefixes.slice(0..index).tap do |prefixes|
        insert_index = prefixes.length > 1 ? -2 : 0
        prefixes.insert insert_index, @theme_name if @theme_name.present?
      end
    end

    # @return [String] a prefix of the mouted path
    def mounted_prefix
      prefix = (@script_name || '').sub(%r{^/}, '')
      prefix << SLASH if prefix.present?
      prefix << resources_path if resources_path
    end

    # @return [String]
    def suffix
      @suffix ||= CellUtils.to_action_prefix @action_name
    end

    def resources_path
      @resources_path ||= @resources_name.try :gsub, COLONS, SLASH
    end
  end
end
