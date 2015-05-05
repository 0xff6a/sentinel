require 'spec_helper'
require 'cache'

describe Cache do
  let(:cache) { Cache.new(3) }

  context 'Initialisation' do
    it 'is initialized with a max size' do
      expect(cache.max_size).to eq 3
    end
  end

  context 'Manipulating data' do
    it 'if the max_size is changed, old elements are deleted until we reach the new max size' do
      cache.fill({old_1: '1', old_2: '2'})
      cache.fill({new_1: '1'})

      cache.max_size = 2

      expect(cache.to_a).to eq([
        [:new_1, '1'],
        [:old_2, '2']
      ])
    end

    it 'retrieving a value updates its ranking' do
      cache.fill({item_1: '1', item_2: '2', item_3: '3'})
      cache[:item_2]

      expect(cache.to_a).to eq([ 
        [:item_2, '2'], 
        [:item_3, '3'],
        [:item_1, '1']
      ])
    end

    it 'updating a value updates its ranking' do
      cache.fill({item_1: '1', item_2: '2', item_3: '3'})
      cache[:item_1] = '4'

      expect(cache.to_a).to eq([ 
        [:item_1, '4'],
        [:item_3, '3'],
        [:item_2, '2']
      ])
    end
  end

  context 'File IO' do
    let(:filepath) { File.expand_path('../tmp/cache.yml', __dir__) }

    before(:each) do
      cache.fill({item_1: '1', item_2: '2'})
      cache.dump_to_file(filepath)
    end

    it 'can be dumped to a YAML file' do
      result = File.read(filepath)

      expect(result).to eq(
        "--- !ruby/object:Cache\n" +
        "max_size: 3\n" +
        "data:\n" +
        "  :item_1: '1'\n" +
        "  :item_2: '2'\n" +
        "observer_state: false\n"
      )
    end

    it 'can be created from a YAML dump file' do
      new_cache = Cache.from_dumpfile(filepath)

      expect(new_cache.max_size).to eq 3
      expect(new_cache.to_a).to eq([
        [:item_2, '2'],
        [:item_1, '1']
      ])
    end
  end
end