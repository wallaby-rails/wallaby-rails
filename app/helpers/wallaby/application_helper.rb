module Wallaby::ApplicationHelper
  # override `actionview/lib/action_view/routing_url_for.rb#url_for`
  def url_for(options = nil)
    if options.is_a?(Hash) && options.slice(:action, :resources).length == 2
      return wallaby_resourceful_url_for options
    end
    super
  end

  # override `actionview/lib/action_view/helpers/rendering_helper.rb#render`
  def render(options = {}, locals = {}, &block)
    caller_view_path = File.dirname caller[0].gsub(%r(:.*\Z), '')
    if caller_view_path =~ %r(/app/views) &&
      !view_paths.map(&:to_path).include?(caller_view_path)
      view_paths << caller_view_path
    end
    super options, locals, &block
  end

  def wallaby_resourceful_url_for(options = {})
    # DEPRECATION WARNING: You are calling a `*_path` helper with the `only_path` option explicitly set to `false`. This option will stop working on path helpers in Rails 5. Use the corresponding `*_url` helper instead.
    options = options.except :only_path
    case options[:action]
    when 'index', 'create'
      wallaby_engine.resources_path options
    when 'new'
      wallaby_engine.new_resource_path options
    when 'edit'
      wallaby_engine.edit_resource_path options
    when 'show', 'update', 'destroy'
      wallaby_engine.resource_path options
    else
      wallaby_engine.url_for options
    end
  end
end
