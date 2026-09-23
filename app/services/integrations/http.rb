require 'net/http'
require 'json'

module Integrations
  class Http
    def self.json(url, method: :get, headers: {}, body: nil, form: nil, read_timeout: 15)
      uri = URI(url)
      request = (method == :post ? Net::HTTP::Post : Net::HTTP::Get).new(uri)
      headers.each { |key, value| request[key] = value }
      if form
        request.set_form_data(form)
      elsif body
        request['Content-Type'] = 'application/json'
        request.body = JSON.generate(body)
      end
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: read_timeout, write_timeout: 15) do |http|
        http.max_retries = 0
        http.request(request)
      end
      raise Unauthorized, 'The connection has expired. Reconnect your account.' if response.code == '401'
      raise Unavailable, 'The provider could not complete this request. Check API access and quota, then try again.' unless response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    rescue Timeout::Error, IOError, SystemCallError, SocketError, OpenSSL::SSL::SSLError, JSON::ParserError
      raise Unavailable, 'The provider could not be reached. Please try again later.'
    end
  end
end
