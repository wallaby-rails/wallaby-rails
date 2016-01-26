class Wallaby::LookupContextWrapper
  def self.original_methods
    ActionView::LookupContext.public_instance_methods - \
      Object.instance_methods - \
      %i( find_template )
  end

  delegate *original_methods, to: :@lookup_context

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
    if ! @templates.has_key? key
      @templates[key] = begin
        yield
      rescue ActionView::MissingTemplate => e
        if Rails.env.development?
          raise
        else
          BlankTemplate.new
        end
      end
    end
    @templates[key]
  end

  class BlankTemplate
    def render *args
    end

    def identifier
    end

    def formats
      [ :html ]
    end
  end
end
