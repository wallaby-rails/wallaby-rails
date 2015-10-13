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
      @templates[key] = begin
        yield
      rescue ActionView::MissingTemplate => e
        e
      end
    end
    raise @templates[key] if @templates[key].is_a? ActionView::MissingTemplate
    @templates[key]
  end
end