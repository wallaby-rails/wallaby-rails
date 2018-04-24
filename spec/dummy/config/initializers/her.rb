if defined? Her
  Her::API.setup url: "http://localhost:3000/admin" do |c|
    # Request
    c.use Her::Middleware::AcceptJSON
    c.use Faraday::Request::UrlEncoded

    # Response
    c.use Her::Middleware::DefaultParseJSON

    # Adapter
    c.use Faraday::Adapter::NetHttp
  end
end
