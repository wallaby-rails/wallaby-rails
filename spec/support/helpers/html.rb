module Html
  def h(str)
    ERB::Util.h str
  end

  # NOTE: this is for capybara inner_html
  def escape(str)
    ERB::Util.h(str).gsub('&quot;', '"').gsub('&#39;', "'")
  end
end

RSpec.configure do |config|
  config.include Html
end
