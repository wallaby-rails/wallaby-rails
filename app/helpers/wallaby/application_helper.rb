module Wallaby
  module ApplicationHelper
    def page_title
      ct('page.title', default: false) || 'Wallaby::Admin'
    end

    def body_class
      [
        action_name,
        resources_name.gsub('::', '__'),
        content_for(:custom_body_class)
      ].compact.join ' '
    end

    def render options = {}, locals = {}, &block
      caller_view_path = File.dirname caller[0].gsub(%r(:.*\Z), '')
      view_paths << caller_view_path
      super options, locals, &block
    end

    def ct *args
      t *args
    end

    def link_to_model model
      decorator = model_decorator model
      name      = Wallaby::Utils.to_resources_name model.to_s
      link_to decorator.model_label, wallaby_engine.resources_path(name)
    end
  end
end
