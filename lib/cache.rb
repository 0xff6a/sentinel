require 'yaml'
require 'observer'

class Cache
  include Observable

  attr_reader :max_size

  def self.from_dumpfile(filepath)
    YAML.load(File.read(filepath))
  end

  def initialize(max_size)
    raise ArgumentError if max_size < 1

    @max_size = max_size
    @data     = {}
  end

  def max_size=(max_size)
    max_size ||= @max_size

    raise ArgumentError if max_size < 1

    @max_size = max_size

    @data.shift while @data.size > @max_size
    notify_change
  end

  def [](key)
    found = true
    value = @data.delete(key){ found = false }

    found ? @data[key] = value : nil
  end

  def []=(key, val)
    @data.delete(key)
    @data[key] = val
    @data.shift if @data.length > @max_size

    notify_change
    val
  end

  def fill(data_h)
    raise ArgumentError if data_h.size > @max_size

    data_h.each { |k, v| self[k] = v }
    
    notify_change
    self
  end

  def dump_to_file(filepath)
    File.write(filepath, YAML.dump(self))
  end

  def to_a
    array = @data.to_a
    array.reverse!
  end

  def delete(key)
    @data.delete(key)
  end

  def clear!
    @data.clear
    notify_change
    self
  end

  def count
    @data.size
  end

  private

  def notify_change
    changed
    notify_observers
  end
end
