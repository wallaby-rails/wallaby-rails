module WebmockHelpers
  def parse_params_for(request)
    Rack::Utils.parse_nested_query request.uri.query
  end

  def parse_body_for(request)
    JSON.parse request.body
  end
end

RSpec.configure do |config|
  config.include WebmockHelpers
end
