class DataSource
  ERR_TO_CATCH = 
  [
    Net::ReadTimeout, 
    Errno::ECONNREFUSED, 
    SocketError
  ]

  def self.from_settings
    #
    # Returns a new DataSource instance initialized from parameters in settings
    # Null -> DataSource
    #
    raise NotImplementedError, 'The from_settings method should be implemented by subclasses'
  end

  def available?
    #
    # Returns whether or not the data source is available
    # Null -> Boolean
    #
    raise NotImplementedError, 'The available? method should be implemented by subclasses'
  end

  def retrieve_all
    #
    # Returns an ES JSON response
    # Null -> JSON
    #
    raise NotImplementedError, 'The retrieve_all method should be implemented by subclasses'
  end

  def retrieve_fields
    #
    # Returns an ES JSON response for a given list of fields 
    # Array[Symbol] -> JSON
    #
    raise NotImplementedError, 'The retrieve_fields method should be implemented by subclasses'
  end
end