module Wallaby
  module ApplicationHelper
    def render_partial partial_view_path, options = {}
      ancestors = controller.class.ancestors.select do |constance|
        constance <= ::ApplicationController
      end

      full_view_paths = ancestors.map do |klass|
        "#{ klass.name.gsub(%r((Application)?Controller), '').underscore }/#{ partial_view_path }".gsub('//', '/').gsub(%r(/([^/]+\Z)), '/_\1')
      end

      target_view_path = full_view_paths.find do |view_path|
        lookup_context.exists? view_path
      end

      if target_view_path
        render target_view_path.gsub('/_', '/'), options
      else
        raise ActionView::MissingTemplate
      end
    end

    def ct *args
      t *args
    end
  end
end
