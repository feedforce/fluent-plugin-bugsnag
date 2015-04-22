require 'net/https'
require 'uri'

module Fluent
  class BugsnagOutput < BufferedOutput
    Plugin.register_output('bugsnag', self)

    config_param :bugsnag_proxy_host, :string, :default => nil
    config_param :bugsnag_proxy_port, :integer, :default => nil
    config_param :bugsnag_proxy_user, :string, :default => nil
    config_param :bugsnag_proxy_password, :string, :default => nil
    config_param :bugsnag_timeout, :integer, :default => nil

    def format(tag, time, record)
      [tag, time, record].to_msgpack
    end

    def write(chunk)
      chunk.msgpack_each do |(tag,time,record)|
        request(record['url'], record['body'])
      end
    end

    private

    def request(url, body)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port, @bugsnag_proxy_host, @bugsnag_proxy_port, @bugsnag_proxy_user, @bugsnag_proxy_password)
      http.read_timeout = @bugsnag_timeout
      http.open_timeout = @bugsnag_timeout

      if uri.scheme == "https"
        http.use_ssl = true
        # the default in 1.9+, but required for 1.8
        # http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request = Net::HTTP::Post.new(path(uri), {"Content-Type" => "application/json"})
      request.body = body
      http.request(request)
    end

    def path(uri)
      uri.path == "" ? "/" : uri.path
    end
  end
end
