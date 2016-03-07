class Wallaby::LookupContextWrapper
  delegate *begin # origin methods
    ActionView::LookupContext.instance_methods \
      - Object.instance_methods - %i( find_template )
  end, to: :@lookup_context

  def initialize(lookup_context)
    @lookup_context = lookup_context
  end

  def find_template(*args)
    key = args.join '/'
    caching key do
      @lookup_context.find_template *args
    end
  end

  protected
  def caching(key)
    @templates ||= {}
    unless @templates.has_key? key
      @templates[key] = begin
        yield
      rescue ActionView::MissingTemplate
        raise if Rails.env.development?
        BlankTemplate.new
      end
    end
    @templates[key]
  end

  class BlankTemplate < ActionView::Template::HTML
    def initialize
      super nil
    end

    def render(*args)
    end
  end
end
