module Wallaby
  # Application helper
  module ApplicationHelper
    # override `actionview/lib/action_view/routing_url_for.rb#url_for`
    def url_for(options = nil)
      if options.respond_to? :to_h
        if options.is_a? ActionController::Parameters
          options = options.permit :action, :resources
        end
        options = options.to_h # convert to hash
        if options[:action].present? && options[:resources].present?
          return wallaby_resourceful_url_for options
        end
      end
      super
    end

    def wallaby_resourceful_url_for(options = {})
      # TODO: DEPRECATION WARNING: You are calling a `*_path` helper with the
      # `only_path` option explicitly set to `false`.
      # This option will stop working on path helpers in Rails 5.
      # Use the corresponding `*_url` helper instead.
      options = options.except :only_path
      case options[:action]
      when 'index', 'create' then wallaby_engine.resources_path options
      when 'new' then wallaby_engine.new_resource_path options
      when 'edit' then wallaby_engine.edit_resource_path options
      when 'show', 'update', 'destroy' then wallaby_engine.resource_path options
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
  end
end
