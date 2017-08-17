module Wallaby
  # base component to build html
  class BaseComponent
    attr_reader :view

    def initialize(view)
      @view = view
    end

    def html_classes(classes)
      { html_options: { class: classes } }
    end

    def dropdown_options
      {
        role: 'button', data: { target: '#', toggle: 'dropdown' },
        aria: { haspopup: 'true', expanded: 'true' }
      }
    end

    %i(a em div form label li ul span nav).each do |tag|
      define_method tag do |*args, &block|
        view.content_tag(*args.unshift(tag), &block)
      end
    end

    # TODO: might take this out in the future
    def method_missing(method_id, *args, &block)
      return super unless view.respond_to? method_id
      view.public_send method_id, *args, &block
    end

    # TODO: might take this out in the future
    def respond_to_missing?(method_id, include_all)
      super || view.respond_to?(method_id)
    end
  end
end
