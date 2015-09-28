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

    def link_to_model model_class
      model_decorator = Wallaby::ModelDecoratorFinder.find model_class
      resources_name  = Wallaby::Utils.to_resources_name model_class.to_s
      link_to model_decorator.model_label, wallaby_engine.resources_path(resources_name)
    end
  end
end
