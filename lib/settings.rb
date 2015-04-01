require 'yaml'

module Settings
  FILEPATH = File.expand_path('../settings.yml', __dir__)
  DATA     = YAML::load_file(FILEPATH)

  class Elasticsearch
    attr_reader :user,
                :pass,
                :host,
                :port,
                :scheme

    def self.default
      host    = DATA['elasticsearch']['host']
      port    = DATA['elasticsearch']['port']

      raise "Cannot find Elasticsearch host. Please set it first" unless host
      raise "Cannot find Elasticsearch port. Please set it first" unless port

      new(host, port)
    end

    def initialize(host, port)
      @host   = host
      @port   = port
    end
  end

  module_function
  @elasticsearch_client = Elasticsearch.default

  def elasticsearch_client
    @elasticsearch_client
  end
end