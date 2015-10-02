module Wallaby::ApplicationHelper
  def page_title
    ct('page.title', default: false) || 'Wallaby::Admin'
  end

  def body_class
    [
      action_name,
      (resources_name || '').gsub('::', '__'),
      content_for(:custom_body_class)
    ].compact.join ' '
  end

  def render options = {}, locals = {}, &block
    customize_lookup_context
    caller_view_path = File.dirname caller[0].gsub(%r(:.*\Z), '')
    view_paths << caller_view_path
    super options, locals, &block
  end

  def ct *args
    t *args
  end

  protected
  def customize_lookup_context
    @customize_lookup_context ||= (view_renderer.lookup_context = Wallaby::LookupContextWrapper.new lookup_context)
  end
end
