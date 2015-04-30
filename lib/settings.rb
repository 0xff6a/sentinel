require 'yaml'

module Settings
  path  = File.expand_path('../config/settings.yml', __dir__)
  @data = YAML::load_file(path)

  Api = Struct.new(:name, :host, :port) do
    def initialize(*args)
      super(*args)
      raise "Cannot find #{name} host or port. Please set them first" unless host && port
    end
  end

  module_function

  def mock_api
    Api.new('Mock API', @data['mock_api']['host'], @data['mock_api']['port'])
  end

  def elasticsearch_client
    Api.new('Elasticsearch Client', @data['elasticsearch']['host'], @data['elasticsearch']['port'])
  end
end