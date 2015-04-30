require 'spec_helper'

describe Geolocation::Cache do
  let(:cache) { Geolocation::Cache.new(3) }

  it 'is initialized with a max size' do
    expect(cache.max_size).to eq 3
  end

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