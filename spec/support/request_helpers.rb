module Request
  module HeadersHelpers
    def api_header(version = 1)
      request.headers['Accept'] = "application/vnd.fooda-eiv20.v#{version}"
    end

    def api_authorization_header(token)
      request.headers['Authorization'] = token
    end

    def api_response_format(format = Mime[:json])
      request.headers['Accept'] = "#{format},#{request.headers['Accept']}"
      request.headers['Content-Type'] = format.to_s
    end

    def include_default_accept_headers
      api_header
      api_response_format
    end
  end
end