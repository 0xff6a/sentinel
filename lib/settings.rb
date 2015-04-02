require 'yaml'

module Settings
  FILEPATH = File.expand_path('../settings.yml', __dir__)
  DATA     = YAML::load_file(FILEPATH)

  class Elasticsearch
    attr_reader :host, :port

    def self.default
      host    = DATA['elasticsearch']['host']
      port    = DATA['elasticsearch']['port']

      raise "Cannot find Elasticsearch host or port. Please set them first" unless host && port

      new(host, port)
    end

    def initialize(host, port)
      @host   = host
      @port   = port
    end
  end

  module_function

  def elasticsearch_client
    Elasticsearch.default
  end
end