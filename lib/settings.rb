module Settings
  module_function
  settings_file  = File.expand_path('../settings.yml', __dir__)
  @data          = YAML::load_file(settings_file)

  def elastic_search_url
    @data['elastic_search_url']
  end
end