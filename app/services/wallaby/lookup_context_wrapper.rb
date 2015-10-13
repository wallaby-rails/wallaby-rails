class Wallaby::LookupContextWrapper
  def self.original_methods
    ActionView::LookupContext.instance_methods - Object.instance_methods - %i( find_template )
  end

  delegate *original_methods, to: :@lookup_context

  def initialize lookup_context
    @lookup_context = lookup_context
  end

  def find_template *args
    key = args.join '/'
    cache key do
      @lookup_context.find_template *args
    end
  end

  protected
  def cache key
    @templates ||= {}
    unless @templates.has_key? key
      @templates[key] = yield
    end
    @templates[key]
  rescue ActionView::MissingTemplate
    @templates[key] = nil
  end
end