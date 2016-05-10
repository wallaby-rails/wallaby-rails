require 'erubis'

# TODO: move this kind of logic into a gem called faster rails :)
class Wallaby::CachedCompiledErb < ActionView::Template::Handlers::ERB
  def call(template)
    Rails.cache.fetch "wallaby/views/erb/#{ template.inspect }" do
      super
    end
  end
end
