# frozen_string_literal: true
module RequestSupport
  def http(verb, url, hash = {})
    if Rails::VERSION::MAJOR == 4
      send verb, url, hash[:params], hash[:headers]
    else
      send verb, url, **hash
    end
  end

  def page_html
    @page_html[response] ||= Nokogiri::HTML(response.body)
  end

  def page_json
    @page_json[response] ||= JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include RequestSupport, type: :request
  config.before(:example, type: :request) do
    @page_html = {}
    @page_json = {}
  end
end
