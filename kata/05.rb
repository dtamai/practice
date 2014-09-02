require 'bitarray'
require 'digest'

class BloomFilter

  def initialize(m: 1_000_000, k: 3)
    @m = m
    @k = k
    @bits = BitArray.new(m)
    init_ranges(k)

    load_dict
  end

  def add(word)
    keys(word).each do |p|
      @bits[p] = 1
    end
  end

  def may_contain?(word)
    bits = keys(word).map do |p|
      @bits[p]
    end
    all_ones?(bits)
  end

  # How much bits are 1?
  def set_total
    @bits.total_set
  end

  private

  def keys(word)
    digest = Digest::MD5.hexdigest(word)

    hashes = slice(digest)
    hashes.map do |h|
      h.hex % @m
    end
  end

  def slice(str)
    @ranges.map do |r|
      str[r]
    end
  end

  def all_ones?(bits)
    bits.reduce(&:*) == 1
  end

  def load_dict
    File.open('/usr/share/dict/words', 'r') do |file|
      file.each_line do |line|
        add(line.strip)
      end
    end
  end

  def init_ranges(k)
    each_slice = 32/k
    @ranges = []
    k.times do |n|
      lo = n*each_slice
      hi = (n + 1)*each_slice
      @ranges << Range.new(lo, hi)
    end
    @ranges
  end
end

filter = BloomFilter.new(m: 1_000_000, k: 3)
