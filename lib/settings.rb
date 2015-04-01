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

    def self.from_env
      user    = ENV['ELASTIC_CLIENT_USER']
      pass    = ENV['ELASTIC_CLIENT_PASS']
      host    = DATA['elasticsearch']['host']
      port    = DATA['elasticsearch']['port']
      scheme  = DATA['elasticsearch']['scheme']

      raise "Cannot find Elasticsearch host. Please set it first" unless host
      raise "Cannot find Elasticsearch port. Please set it first" unless port

      new(host, port, user, pass, scheme)
    end

    def initialize(host, port, user, pass, scheme)
      @host   = host
      @port   = port
      @user   = user
      @pass   = pass
      @scheme = scheme
    end
  end

  module_function
  @elasticsearch_client = Elasticsearch.from_env

  def elasticsearch_client
    @elasticsearch_client
  end
end