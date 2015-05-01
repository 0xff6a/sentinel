require 'yaml'

class Cache
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
    val
  end

  def fill(data_h)
    raise ArgumentError if data_h.size > @max_size

    data_h.each { |k, v| self[k] = v }
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

  def has_key?(key)
    @data.has_key?(key)
  end

  def clear!
    @data.clear
  end

  def count
    @data.size
  end
end
