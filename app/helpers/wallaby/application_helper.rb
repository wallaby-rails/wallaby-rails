module Wallaby
  module ApplicationHelper
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
  end
end
