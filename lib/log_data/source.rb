require 'elasticsearch'
require 'settings'

module LogData
  class Source
    attr_reader :client

    def self.from_settings
      s = Settings.elasticsearch_client
      new( s.host,
           s.port,
           s.user,
           s.pass,
           s.scheme )
    end

    def initialize(host, port, user, pass, scheme)
      @client = Elasticsearch::Client.new(hosts: [
        { host: host,
          port: port,
          user: user,
          password: pass,
          scheme: scheme
        } ])
    end
  end
end