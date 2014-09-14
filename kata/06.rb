class Kata06

  attr_reader :words

  def initialize
    @words = []
  end

  def <<(word)
    @words << word
  end

  def find_anagrams
    @h = Hash.new { |h,k| h[k] = Array.new }
    words.each do |w|
      key = w.split(//).sort.join
      @h[key] << w
    end
    @h = @h.select { |h,v| v.size > 1 }
    @h.values
  end

  def longest_anagram
    @h.keys.map do |k|
      [k.size, k, @h[k]]
    end.max { |a,b| a[0] <=> b[0] }
  end

  def most_anagrams
    @h.values.map do |ana|
      [ana.size, ana]
    end.max { |a,b| a[0] <=> b[0] }
  end
end

require 'minitest/autorun'
require 'minitest/pride'
class Kata06Test < MiniTest::Test

  def test_find_anagrams
    finder = Kata06.new
    finder << 'act'
    finder << 'cat'
    finder << 'Tac'
    finder << 'dog'
    finder << 'god'
    finder << 'pact'

    anagrams = finder.find_anagrams
    assert_equal [['act','cat'], ['dog','god']], anagrams
  end

  def test_wordlist
    finder = Kata06.new
    File.open './kata/data/wordlist.txt', 'rb:iso-8859-1:utf-8' do |file|
      file.each_line do |l|
        finder << l.strip
      end
    end

    anagrams = finder.find_anagrams
    assert_equal 20683, anagrams.size

    puts finder.longest_anagram.to_s
    puts finder.most_anagrams.to_s
  end
end


