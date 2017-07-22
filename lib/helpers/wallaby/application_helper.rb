module Wallaby
  # Application helper
  module ApplicationHelper
    # override `actionview/lib/action_view/routing_url_for.rb#url_for`
    def url_for(options = nil)
      # possible Hash or Parameters
      if options.respond_to?(:to_h) \
        && options[:resources].present? && options[:action].present?
        return wallaby_resourceful_url_for options
      end
      super(options)
    end

    def wallaby_resourceful_url_for(options = {})
      # TODO: DEPRECATION WARNING: You are calling a `*_path` helper with the
      # `only_path` option explicitly set to `false`.
      # This option will stop working on path helpers in Rails 5.
      # Use the corresponding `*_url` helper instead.
      hash = normalize_params(options).except(:only_path)
      case hash[:action]
      when 'index', 'create' then wallaby_engine.resources_path hash
      when 'export' then wallaby_engine.export_resources_path hash
      when 'new' then wallaby_engine.new_resource_path hash
      when 'edit' then wallaby_engine.edit_resource_path hash
      when 'show', 'update', 'destroy' then wallaby_engine.resource_path hash
      else wallaby_engine.url_for options
      end
    end

    def stylesheet_link_tag(*sources)
      default_options = { 'data-turbolinks-track' => true }
      options = default_options.merge!(sources.extract_options!.stringify_keys)
      super(*sources, options)
    end

    def javascript_include_tag(*sources)
      default_options =
        { 'data-turbolinks-track' => true, 'data-turbolinks-eval' => false }
      options = default_options.merge!(sources.extract_options!.stringify_keys)
      super(*sources, options)
    end

    private

    def normalize_params(options)
      return options unless options.is_a? ActionController::Parameters
      options.to_h.tap do |hash|
        hash[:resources] = options[:resources]
        hash[:action] = options[:action]
      end
    end
  end
end
